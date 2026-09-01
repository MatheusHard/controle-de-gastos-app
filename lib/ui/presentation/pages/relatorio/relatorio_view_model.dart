import 'package:flutter/material.dart';

import '../../../core/constants/enums/type_file_enum.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dtos/request/get/email_request_dto.dart';
import '../../../data/dtos/request/get/gasto_request_dto.dart';
import '../../../data/model/user.dart';
import '../../../data/repositories/relatorio_repository.dart';


class RelatorioViewModel extends ChangeNotifier {
  final RelatorioRepository repository;

  RelatorioViewModel({
    required this.repository,
    GastoRequestDTO? filtros,
  }) : _filtros = filtros;

  TypeFileEnum _selected = TypeFileEnum.pdf;
  bool _isLoading = false;
  User? _user;
  GastoRequestDTO? _filtros;
  TypeFileEnum get selected => _selected;
  bool get isLoading => _isLoading;
  User? get user => _user;
  GastoRequestDTO? get filtros => _filtros;

  /// Inicializar dados
  Future<void> init() async {
    await carregarUsuario();
  }

  /// Alterar formato selecionado
  void selecionarTipo(TypeFileEnum value) {
    _selected = value;
    notifyListeners();
  }

  /// Executar ação conforme formato selecionado
  Future<void> gerarRelatorio() async {
    if (_filtros == null) {
      return;
    }

    switch (_selected) {
      case TypeFileEnum.pdf:
        await baixarPdf();
        break;

      case TypeFileEnum.excel:
        await baixarExcel();
        break;

      case TypeFileEnum.email:
        await enviarEmail();
        break;
    }
  }

  /// Gerar Excel
  Future<void> baixarExcel() async {
    if (_filtros == null) return;

    _setLoading(true);

    try {
      await repository.baixarExcel(_filtros!);
    } finally {
      _setLoading(false);
    }
  }

  /// Gerar PDF
  Future<void> baixarPdf() async {
    if (_filtros == null) return;

    _setLoading(true);

    try {
      await repository.baixarPdf(_filtros!);
    } finally {
      _setLoading(false);
    }
  }

  /// Enviar Email
  Future<void> enviarEmail() async {
    if (_filtros == null || _user == null) return;

    _setLoading(true);

    try {
      final request = EmailRequestDTO();

      _filtros!.userId = _user!.id;

      request.nomeUsuario = _user!.username;
      request.destinatario = _user!.email;
      request.filters = _filtros;
      request.corpo = '';
      request.assunto = '';
      request.remetente = '';
      request.createdAt = DateTime.now().toIso8601String();
      request.updatedAt = DateTime.now().toIso8601String();
      request.file = null;

      await repository.enviarEmail(request);
    } finally {
      _setLoading(false);
    }
  }

  /// Carregar usuário
  Future<void> carregarUsuario() async {
    _user = await Utils.recuperarUser();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}