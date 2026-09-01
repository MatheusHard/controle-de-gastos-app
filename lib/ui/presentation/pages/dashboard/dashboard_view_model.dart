import 'package:flutter/foundation.dart';

import '../../../core/utils/utils.dart';
import '../../../data/dtos/dashboarding/gastos_mensais.dart';
import '../../../data/dtos/request/get/dashboard_request_dto.dart';
import '../../../data/model/user.dart';
import '../../../data/repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {

  final DashboardRepository repository;

  User? user;

  List<GastosMensais> listaMensal = [];

  double totalGeral = 0;

  bool isLoading = true;

  String? errorMessage;

  DashboardViewModel({
    required this.repository,
  });

  Future<void> init() async {
    await _loadingUser();
    await loadDashboard();
  }

  Future<void> _loadingUser() async {
    user = await Utils.recuperarUser();
  }

  Future<void> loadDashboard() async {

    try {

      isLoading = true;
      errorMessage = null;

      notifyListeners();

      // Verifica se existe usuário
      if (user?.id == null) {
        errorMessage ='Usuário não encontrado.';

        return;
      }

      // Filtros da consulta
      final filters = DashboardRequestDto()
        ..deletado = false
        ..userId = user!.id;

      // Consulta através do Repository
      final dashboard =
      await repository.getTotais(filters);

      // Verifica retorno
      if (dashboard == null) {

        errorMessage =
        'Não foi possível carregar o dashboard.';

        return;
      }

      // Atualiza dados
      listaMensal =
          dashboard.totaisPorMes ?? [];

      totalGeral =
          dashboard.somaTotal ?? 0;

    } catch (e, stackTrace) {

      errorMessage =
      'Erro ao carregar o dashboard.';

      debugPrint(
        'Erro Dashboard: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}