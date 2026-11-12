import 'dart:io';

import 'package:controle_de_gastos_app/ui/data/repositories/gasto_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:controle_de_gastos_app/ui/data/dtos/request/created/gasto_created_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';

import '../../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../../core/utils/utils.dart';
import '../../../../data/service/share/share_service.dart';


class AddFaturaViewModel extends ChangeNotifier {
  final GastoRepository gastoRepository;
  final ImagePicker _picker = ImagePicker();
  final ShareService _shareService = ShareService();
  bool _disposed = false;


  User? user;
  Gasto? gasto;

  bool isLoading = false;
  bool isPago = false;
  bool isEdit = false;

  File? imagem;

  String? errorMessage;

  AddFaturaViewModel({this.gasto, required this.gastoRepository}) {
    isEdit = gasto?.id != null;
    isPago = gasto?.pago ?? false;
  }

  // Inicialização
  Future<void> init() async {
    try {
      user = await Utils.recuperarUser();
    } catch (e) {
      errorMessage = 'Erro ao carregar dados: $e';
    }

    if (!_disposed) notifyListeners();
  }

  // Atualizar status de pagamento
  void setPago(bool value) {
    isPago = value;
    notifyListeners();
  }

  // Atualizar imagem selecionada
  void _setImagem(File file, File? sharedImage) {
    if (_disposed) return;
    imagem = file;
    _shareService.clearImage(sharedImage);

    notifyListeners();
  }

  // Tirar foto
  Future<void> tirarFoto() async {
    final sharedImage = _shareService.image.value;
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      errorMessage = 'Permissão de câmera negada';
      if (!_disposed) notifyListeners();
      return;
    }

    final fotoFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (fotoFile == null) return;

    final originalFile = File(fotoFile.path);

    final compressedBytes =
        await Utils.compressImageBytes(originalFile);

    if (compressedBytes != null) {
      _setImagem(originalFile, sharedImage);
    }
  }

  // Selecionar imagem da galeria
  Future<void> getImage(ImageSource source) async {
    final sharedImage = _shareService.image.value;
    final galleryFile = await _picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );
    if (galleryFile == null) return;

    final originalFile = File(galleryFile.path);
    final compressedBytes = await Utils.compressImageBytes(originalFile);

    if (compressedBytes != null) {
      _setImagem(originalFile, sharedImage);
    }
  }

  // Ler valor pela foto
  Future<String?> loadingFieldsByPhoto(XFile? foto) async {
    return await Utils.loadingFieldsByPhoto(foto, "valor");
  }

  // Gerar objeto Gasto
  Future<GastoCreatedRequestDTO> _generateGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
    required File? currentImage,
  }) async {
    Uint8List? currentBytes;

    if (currentImage != null) {
      currentBytes = await Utils.compressImageBytes(currentImage);
      if (currentBytes == null) {
        throw Exception('Não foi possível ler a imagem selecionada.');
      }
    }

    final g = GastoCreatedRequestDTO();

    _validate();

    g.descricao = descricao;
    g.valor = valor.isNotEmpty ? double.parse(valor) : 0;
    g.vencimento = vencimento.toIso8601String();
    g.createdAt = DateTime.now().toIso8601String();
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = currentBytes != null ? await Utils.base64String(currentBytes) : null;
    g.photoName = "foto_${user?.id}${DateTime.now().millisecondsSinceEpoch}.jpg";
    g.userId = user?.id;
    g.agendaDePagamentoId = gasto?.agendaDePagamento?.id;
    g.deletado = gasto?.deletado ?? false;
    g.statusPagamento = isPago
        ? StatusPagamentoEnum.PAGO
        : Utils.isVencido(gasto?.vencimento)
            ? StatusPagamentoEnum.VENCIDO
            : StatusPagamentoEnum.NAO_PAGO;
    g.pago = isPago;

    return g;
  }

  //Valid
  void _validate() {
    if(gasto?.agendaDePagamento?.id == null) throw Exception("Não adicionar sem Agenda de Pagamento.");
    if(user?.id == null) throw Exception("Não adicionar sem Usuário.");
  }

  // Salvar gasto
  Future<bool> salvarGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
  }) async {
    if (_shareService.importingPdf.value) {
      errorMessage = 'Aguarde o PDF compartilhado abrir antes de salvar.';
      return false;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final sharedImage = _shareService.image.value;
    try {
      final request = await _generateGasto(
        descricao: descricao,
        valor: valor,
        vencimento: vencimento,
        currentImage: sharedImage ?? imagem,
      );

      final sucesso = await gastoRepository.addGasto(request);

      if (sucesso) {
        _shareService.clearImage(sharedImage);
      } else {
        errorMessage = 'Não foi possível salvar o gasto.';
      }

      return sucesso;
    } catch (e) {
      errorMessage = 'Erro ao cadastrar o gasto: $e';
      return false;
    } finally {
      isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
