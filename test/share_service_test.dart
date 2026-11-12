import 'dart:async';
import 'dart:io';

import 'package:controle_de_gastos_app/ui/data/service/share/share_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_handler/share_handler.dart';

class _ShareHandler extends ShareHandlerPlatform {
  final initialMedia = Completer<SharedMedia?>();
  final media = StreamController<SharedMedia>();

  @override
  Future<SharedMedia?> getInitialSharedMedia() => initialMedia.future;

  @override
  Stream<SharedMedia> get sharedMediaStream => media.stream;
}

SharedMedia _imageMedia(File file) => SharedMedia(
  attachments: [
    SharedAttachment(path: file.path, type: SharedAttachmentType.image),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uma imagem antiga não sobrescreve nem limpa a mais recente', () async {
    final directory = await Directory.systemTemp.createTemp('share_test_');
    addTearDown(() => directory.delete(recursive: true));
    final initial = await File('${directory.path}/initial.jpg').create();
    final first = await File('${directory.path}/first.jpg').create();
    final second = await File('${directory.path}/second.jpg').create();
    final pdf = await File('${directory.path}/comprovante.PDF').create();
    final preview = await File('${directory.path}/preview.jpg').create();
    final renderResult = Completer<String>();
    const pdfChannel = MethodChannel('controle_de_gastos/shared_pdf');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(pdfChannel, (call) async {
      expect(call.method, 'renderFirstPage');
      expect(call.arguments, {'path': pdf.path});
      return renderResult.future;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(pdfChannel, null));

    final originalHandler = ShareHandlerPlatform.instance;
    final handler = _ShareHandler();
    ShareHandlerPlatform.instance = handler;
    addTearDown(() async {
      await handler.media.close();
      ShareHandlerPlatform.instance = originalHandler;
    });

    final service = ShareService();
    final initialization = service.init();
    await service.init();

    Future<File> share(SharedMedia media) async {
      final received = Completer<File>();
      void onImage() => received.complete(service.image.value!);
      service.image.addListener(onImage);
      handler.media.add(media);
      try {
        return await received.future.timeout(const Duration(seconds: 5));
      } finally {
        service.image.removeListener(onImage);
      }
    }

    final firstReceived = await share(_imageMedia(first));
    handler.initialMedia.complete(_imageMedia(initial));
    await initialization;
    expect(service.image.value, same(firstReceived));
    expect(firstReceived.path, first.path);

    final secondReceived = await share(_imageMedia(second));
    service.clearImage(firstReceived);
    expect(service.image.value, same(secondReceived));
    expect(secondReceived.path, second.path);

    service.clearImage(secondReceived);
    expect(service.image.value, isNull);

    final importing = Completer<void>();
    void onImport() {
      if (service.importingPdf.value) importing.complete();
    }

    service.importingPdf.addListener(onImport);
    final imported = share(
      SharedMedia(
        attachments: [
          SharedAttachment(path: pdf.path, type: SharedAttachmentType.file),
        ],
      ),
    );
    await importing.future.timeout(const Duration(seconds: 5));
    service.importingPdf.removeListener(onImport);
    expect(service.image.value, isNull);

    renderResult.complete(preview.path);
    final pdfReceived = await imported;
    expect(pdfReceived.path, preview.path);
    expect(service.isPdfPreview(pdfReceived), isTrue);
    expect(service.importingPdf.value, isFalse);
    service.clearImage(pdfReceived);
    expect(service.image.value, isNull);
  });
}
