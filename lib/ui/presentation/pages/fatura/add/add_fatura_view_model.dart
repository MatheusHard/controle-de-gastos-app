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


class AddFaturaViewModel extends ChangeNotifier {
  final GastoRepository gastoRepository;
  final ImagePicker _picker = ImagePicker();


  User? user;
  Gasto? gasto;

  bool isLoading = false;
  bool isPago = false;
  bool isEdit = false;

  File? imagem;
  Uint8List? bytes;

  String? errorMessage;

  AddFaturaViewModel({this.gasto, required this.gastoRepository}) {
    isEdit = gasto?.id != null;
    isPago = gasto?.pago ?? false;
  }

  // Inicialização
  Future<void> init() async {
    try {
      user = await Utils.recuperarUser();

      // 🔥 Carrega imagem compartilhada, se existir
      await _onImageShared();
    } catch (e) {
      errorMessage = 'Erro ao carregar dados: $e';
    }

    notifyListeners();
  }

  // Atualizar status de pagamento
  void setPago(bool value) {
    isPago = value;
    notifyListeners();
  }

  // Atualizar imagem selecionada
  void _setImagem(File file, Uint8List compressedBytes) {
    Utils.imageShareNotifier.value = null;

    imagem = file;
    bytes = compressedBytes;

    notifyListeners();
  }

  // Tirar foto
  Future<void> tirarFoto() async {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      errorMessage = 'Permissão de câmera negada';
      notifyListeners();
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
      _setImagem(originalFile, compressedBytes);
    }
  }

  // Selecionar imagem da galeria
  Future<void> getImage(ImageSource source) async {

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
      _setImagem(originalFile, compressedBytes);
    }
  }

  // Ler valor pela foto
  Future<String?> loadingFieldsByPhoto(XFile? foto) async {
    return await Utils.loadingFieldsByPhoto(foto, "valor");
  }

  // Gerar objeto Gasto
  Future<GastoCreatedRequestDTO> generateGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
  }) async {
    final currentImage = Utils.imageShareNotifier.value ?? imagem;

    Uint8List? currentBytes;

    if (currentImage != null) {
      currentBytes = await Utils.compressImageBytes(currentImage);
    }

    final g = GastoCreatedRequestDTO();

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

  // Salvar gasto
  Future<bool> salvarGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = await generateGasto(
        descricao: descricao,
        valor: valor,
        vencimento: vencimento,
      );

      final sucesso = await gastoRepository.addGasto(request);

      if (!sucesso) {
        errorMessage = 'Não foi possível salvar o gasto.';
      }

      return sucesso;
    } catch (e) {
      errorMessage = 'Erro ao cadastrar o gasto: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
//_validate()
  // Limpar imagem compartilhada
  void cleanWidgets() {
    Utils.imageShareNotifier.value = null;
  }

  // Carregar imagem compartilhada
  Future<void> _onImageShared() async {
    final file = Utils.imageShareNotifier.value;

    if (file == null) return;
    await Utils.saveImageShare(file);
    final compressedBytes = await Utils.compressImageBytes(file);
    if (compressedBytes != null) {
      imagem = file;
      bytes = compressedBytes;
    }
  }

  @override
  void dispose() {
    cleanWidgets();
    super.dispose();
  }
}