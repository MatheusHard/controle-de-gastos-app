import 'package:flutter/foundation.dart';

import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/updated/gasto_updated_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';

import '../../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../../core/utils/utils.dart';
import '../../../../data/dtos/request/created/agenda_de_pagameto_created_request_dto.dart';
import '../../../../data/dtos/request/get/agenda_de_pagamento_request_dto.dart';
import '../../../../data/model/user.dart';
import '../../../../data/repositories/agenda_de_pagamento_repository.dart';
import '../../../../data/repositories/gasto_repository.dart';


class FaturaViewModel extends ChangeNotifier {

  final GastoRepository gastoRepository;
  final AgendaDePagamentoRepository agendaDePagamentoRepository;

  FaturaViewModel({
    required this.gastoRepository,
    required this.agendaDePagamentoRepository
  });

  User? user;
  AgendaDePagamento faturaAtual = AgendaDePagamento();
  List<Gasto> listaGastos = [];
  bool isLoading = true;
  String? errorMessage;

  // Inicialização
  Future<void> init() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _loadingUser();
      await _loadingFaturaAtual();
    } catch (e) {
      errorMessage = 'Erro ao carregar a fatura: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Carregar usuário
  Future<void> _loadingUser() async {
    user = await Utils.recuperarUser();
  }

  // Carregar fatura atual
  Future<void> _loadingFaturaAtual() async {
    final filters = AgendaDePagamentoRequestDTO();

    filters.dataInicial = Utils.dateFirstOrLast(true);
    filters.dataFinal = Utils.dateFirstOrLast(false);
    filters.deletado = false;
    filters.userId = user?.id;

    await _getOrAddFatura(filters);
    _atualizarStatusPagamento();
  }

  // Buscar ou criar fatura
  Future<void> _getOrAddFatura(
    AgendaDePagamentoRequestDTO filters,
  ) async {
    final fatura = await agendaDePagamentoRepository.getOneByFilter(filters);

    if (fatura == null) {
      faturaAtual = (await agendaDePagamentoRepository.addAgendaDePagamento(await _generateFatura(),))!;
    } else {
      faturaAtual = fatura;
    }

    await _getGastos();
  }

  // Gerar fatura
  Future<AgendaDePagamentoCreatedRequestDTO> _generateFatura() async {
    final dataAtual = DateTime.now().toIso8601String();

    final a = AgendaDePagamentoCreatedRequestDTO();

    a.deletado = false;
    a.updatedAt = dataAtual;
    a.createdAt = dataAtual;
    a.userId = user?.id;

    return a;
  }

  // Atualizar status de pagamento
  void _atualizarStatusPagamento() {
    for (final gasto in listaGastos) {
      gasto.statusPagamento =
          Utils.isVencido(gasto.vencimento) && gasto.pago! == false
              ? StatusPagamentoEnum.VENCIDO
              : gasto.statusPagamento;

      gasto.agendaDePagamento = faturaAtual;
    }
  }

  // Excluir gasto
  Future<bool> deletarGasto(Gasto gasto) async {
    try {
      final request = _generateDelGasto(gasto);

      final sucesso = await gastoRepository.updateGasto(
        request,
        user?.id ?? 0,
      );

      if (sucesso) {
        listaGastos.removeWhere(
          (item) => item.id == gasto.id,
        );

        notifyListeners();
      }

      return sucesso;
    } catch (e) {
      errorMessage = 'Erro ao excluir gasto: $e';
      notifyListeners();
      return false;
    }
  }

  // Gerar objeto de exclusão
  GastoUpdatedRequestDto _generateDelGasto(Gasto gasto) {
    final g = GastoUpdatedRequestDto();

    g.id = gasto.id;
    g.descricao = gasto.descricao;
    g.valor = gasto.valor;
    g.vencimento = gasto.vencimento;
    g.createdAt = gasto.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();

    g.imagemBase64 = null;
    g.photoName = null;

    g.userId = user?.id;
    g.agendaDePagamentoId = gasto.agendaDePagamento?.id;

    g.deletado = true;
    g.statusPagamento = gasto.statusPagamento;
    g.pago = gasto.pago;

    return g;
  }

  // Buscar gastos
  Future<void> _getGastos() async {
    final filters = GastoRequestDTO();

    filters.deletado = false;
    filters.agendaDePagamentoId = faturaAtual.id;

    listaGastos = await gastoRepository.getListByFilter(filters);
  }

  // Recarregar gastos após adicionar/editar
  Future<void> refresh() async {
    await _getGastos();
    _atualizarStatusPagamento();
    notifyListeners();
  }
}