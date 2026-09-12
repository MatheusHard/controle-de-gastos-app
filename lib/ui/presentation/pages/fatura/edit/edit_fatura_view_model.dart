import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:controle_de_gastos_app/ui/core/constants/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/updated/gasto_updated_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/gasto_api.dart';

import '../../../../data/repositories/gasto_repository.dart';

class EditFaturaViewModel extends ChangeNotifier {

  final GastoRepository _gastoRepository;
  final ImagePicker _picker = ImagePicker();

EditFaturaViewModel({
  Gasto? gasto,
  required GastoRepository gastoRepository,
})  : gasto = gasto,
      _gastoRepository = gastoRepository {
  isPago = gasto?.pago ?? false;
}

  User? user;
  Gasto? gasto;

  File? imagem;
  dynamic bytes;

  bool isLoading = false;
  bool isPago = false;

  String photoGalleryUrl = '';
  String baseUrlMsImagem = '';

  String? errorMessage;

  bool get isEdit => gasto?.id != null;

  Future<void> init() async {
    try {
      _setLoading(true);
      errorMessage = null;

      await _loadingUser();
      _loadingGasto();
      await _initPrefs();
      await _getUrlImg(gasto?.photoName ?? '');
    } catch (e) {
      errorMessage = 'Erro ao inicializar a tela: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> _loadingUser() async {
    user = await Utils.recuperarUser();
  }

  void _loadingGasto() {
    isPago = gasto?.pago ?? false;
  }

  void setPago(bool value) {
    isPago = value;
    notifyListeners();
  }

  Future<void> tirarFoto() async {
    try {
      final permission = await Permission.camera.request();

      if (!permission.isGranted) {
        errorMessage = 'Permissão da câmera negada.';
        notifyListeners();
        return;
      }

      final fotoFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      await _processarImagem(fotoFile);
    } catch (e) {
      errorMessage = 'Erro ao tirar foto: $e';
      notifyListeners();
    }
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final galleryFile = await _picker.pickImage(
        source: source,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50,
      );

      await _processarImagem(galleryFile);
    } catch (e) {
      errorMessage = 'Erro ao selecionar imagem: $e';
      notifyListeners();
    }
  }

  Future<void> _processarImagem(XFile? fotoFile) async {
    if (fotoFile == null) {
      return;
    }

    final originalFile = File(fotoFile.path);

    final compressedBytes = await Utils.compressImageBytes(
      originalFile,
    );

    if (compressedBytes == null) {
      errorMessage = 'Não foi possível comprimir a imagem.';
      notifyListeners();
      return;
    }

    imagem = originalFile;
    bytes = compressedBytes;

    notifyListeners();
  }

  Future<void> loadingFieldsByPhoto(XFile? foto) async {
    try {
      final valor = await Utils.loadingFieldsByPhoto(
        foto,
        'valor',
      );

      if (valor != null && valor.isNotEmpty) {
        // A View pode preencher o controller com esse valor.
        // O ViewModel não precisa conhecer TextEditingController.
      }
    } catch (e) {
      errorMessage = 'Erro ao ler os dados da imagem: $e';
      notifyListeners();
    }
  }

  Future<GastoUpdatedRequestDto> generateGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
  }) async {
    final request = GastoUpdatedRequestDto();

    _validate();

    request.id = gasto?.id;
    request.descricao = descricao;

    request.valor = valor.isNotEmpty
        ? double.parse(
            valor.replaceAll(',', '.'),
          )
        : 0;

    request.vencimento = vencimento.toIso8601String();
    request.createdAt = gasto?.createdAt;
    request.updatedAt = DateTime.now().toIso8601String();

    request.imagemBase64 = bytes != null
        ? await Utils.base64String(bytes)
        : null;

    request.photoName = gasto?.photoName;
    request.userId = user?.id;
    request.agendaDePagamentoId = gasto?.agendaDePagamento?.id;
    request.deletado = gasto?.deletado ?? false;

    request.statusPagamento = isPago
        ? StatusPagamentoEnum.PAGO
        : Utils.isVencido(
            vencimento.toIso8601String(),
          )
            ? StatusPagamentoEnum.VENCIDO
            : StatusPagamentoEnum.NAO_PAGO;

    request.pago = isPago;

    return request;
  }

  //Valid
  _validate(){
    if(gasto?.agendaDePagamento?.id == null) throw Exception("Não adicionar sem Agenda de Pagamento.");
    if(user?.id == null) throw Exception("Não adicionar sem Usuário.");
    if(gasto?.id == null) throw Exception("Não adicionar sem Gasto.");
   }

  Future<bool> salvarGasto({
    required String descricao,
    required String valor,
    required DateTime vencimento,
  }) async {
    try {
      _setLoading(true);
      errorMessage = null;

      final request = await generateGasto(
        descricao: descricao,
        valor: valor,
        vencimento: vencimento,
      );

      final sucesso = await _gastoRepository.updateGasto(
        request,
        user?.id ?? 0,
      );

      return sucesso;
    } catch (e) {
      errorMessage = 'Erro ao atualizar o gasto: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _initPrefs() async {
    baseUrlMsImagem = await Utils.baseUrlMsImagem();
  }

  Future<void> _getUrlImg(String photoName) async {
    photoGalleryUrl =
        '$baseUrlMsImagem/${Utils.URL_UPLOAD}$photoName';
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}