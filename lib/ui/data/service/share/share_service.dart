import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_handler/share_handler.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  static const _pdfChannel = MethodChannel('controle_de_gastos/shared_pdf');
  static final _imageExtension = RegExp(
    r'\.(avif|bmp|gif|heic|heif|jpe?g|png|webp)$',
    caseSensitive: false,
  );
  factory ShareService() => _instance;

  ShareService._internal();

  final _handler = ShareHandler.instance;
  final _image = ValueNotifier<File?>(null);
  final _error = ValueNotifier<String?>(null);
  final _importingPdf = ValueNotifier<bool>(false);
  File? _pdfPreview;
  int? _pendingPdfSequence;
  bool _initialized = false;
  int _nextSequence = 0;
  int _acceptedSequence = -1;

  ValueListenable<File?> get image => _image;
  ValueListenable<String?> get error => _error;
  ValueListenable<bool> get importingPdf => _importingPdf;

  bool isPdfPreview(File? file) => file != null && identical(file, _pdfPreview);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _handler.sharedMediaStream.listen(
      (media) => _receiveImage(media, ++_nextSequence),
      onError: (Object error) => debugPrint('Erro ao receber imagem: $error'),
    );

    try {
      final media = await _handler.getInitialSharedMedia();
      if (media != null) {
        await _receiveImage(media, 0);
      }
    } catch (error) {
      debugPrint('Erro ao receber imagem inicial: $error');
    }
  }

  Future<void> _receiveImage(SharedMedia media, int sequence) async {
    final attachments = media.attachments;
    if (attachments == null) return;

    for (final attachment in attachments.reversed) {
      if (sequence <= _acceptedSequence) return;
      if (attachment == null || attachment.path.isEmpty) continue;
      final isPdf = attachment.path.toLowerCase().endsWith('.pdf');
      final isImage =
          attachment.type == SharedAttachmentType.image ||
          (attachment.type == SharedAttachmentType.file &&
              _imageExtension.hasMatch(attachment.path));
      if (!isImage && !isPdf) continue;

      final file = File(attachment.path);
      if (isPdf) {
        await _receivePdf(file, sequence);
        return;
      }
      if (await file.exists()) {
        if (sequence > _acceptedSequence) {
          _acceptedSequence = sequence;
          if (sequence > (_pendingPdfSequence ?? sequence)) {
            _pendingPdfSequence = null;
            _importingPdf.value = false;
          }
          _pdfPreview = null;
          _error.value = null;
          _image.value = file;
        }
        return;
      }
    }
  }

  Future<void> _receivePdf(File file, int sequence) async {
    if (sequence < (_pendingPdfSequence ?? sequence)) return;
    _pendingPdfSequence = sequence;
    _error.value = null;
    _importingPdf.value = true;
    try {
      final path = await _pdfChannel.invokeMethod<String>('renderFirstPage', {
        'path': file.path,
      });
      if (path == null) throw StateError('Prévia do PDF indisponível.');
      final preview = File(path);
      if (sequence <= _acceptedSequence || sequence != _pendingPdfSequence) {
        await preview.delete();
        return;
      }
      _acceptedSequence = sequence;
      _pdfPreview = preview;
      _error.value = null;
      _image.value = preview;
    } catch (error) {
      if (sequence > _acceptedSequence && sequence == _pendingPdfSequence) {
        _acceptedSequence = sequence;
        _error.value = 'Não foi possível abrir o PDF compartilhado.';
      }
      debugPrint('Erro ao abrir PDF compartilhado: $error');
    } finally {
      if (sequence == _pendingPdfSequence) {
        _pendingPdfSequence = null;
        _importingPdf.value = false;
      }
    }
  }

  void clearImage(File? image) {
    if (image != null && identical(_image.value, image)) {
      _pdfPreview = null;
      _image.value = null;
    }
  }
}
