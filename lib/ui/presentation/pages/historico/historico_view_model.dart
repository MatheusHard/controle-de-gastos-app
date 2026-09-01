import 'package:flutter/material.dart';

import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/gasto_api.dart';

import '../../../core/constants/enums/status_pagamento_enum.dart';

/// ViewModel responsável por toda a lógica de estado e regras de negócio
/// da tela de Histórico. Não conhece Widgets — apenas expõe estado e
/// comportamentos que a View consome via `context.watch`/`context.read`.
class HistoricoViewModel extends ChangeNotifier {
  User? user;
  List<Gasto> listaGastos = [];
  bool isLoading = true;
  double total = 0;
  GastoRequestDTO? filtros;

  final DateTime _today = DateTime.now();

  late DateTime? dataInicial = DateTime(_today.year, _today.month, 1);
  late DateTime? dataFinal = _today;
  StatusPagamentoEnum? statusPagamento;
  String? descricao;

  /// Ponto de entrada chamado ao abrir a tela.
  Future<void> initialize() async {
    await _loadUser();
    await getGastos();
  }

  Future<void> _loadUser() async {
    user = await Utils.recuperarUser();
    notifyListeners();
  }

  Future<void> getGastos() async {
    isLoading = true;
    notifyListeners();

    filtros = GastoRequestDTO()
      ..deletado = false
      ..dataInicial = dataInicial?.toIso8601String()
      ..dataFinal = dataFinal?.toIso8601String()
      ..statusPagamento = statusPagamento
      ..userId = user?.id
      ..descricao = descricao;

    final gastos = await GastoApi().getListByFilter(filtros!);

    listaGastos = gastos;
    total = Utils.sumTotalGastos(gastos);
    isLoading = false;
    notifyListeners();
  }

  /// Aplica os filtros vindos do bottom sheet e recarrega os gastos.
  Future<void> aplicarFiltros({
    required DateTime? dataInicial,
    required DateTime? dataFinal,
    required StatusPagamentoEnum? status,
    required String? descricao,
  }) async {
    this.dataInicial = dataInicial;
    this.dataFinal = dataFinal;
    statusPagamento = status;
    this.descricao = descricao;
    await getGastos();
  }
}
