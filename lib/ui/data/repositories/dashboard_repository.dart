import '../dtos/dashboarding/totais_mensais_response.dart';
import '../dtos/request/get/dashboard_request_dto.dart';
import '../service/api/dashboard_api.dart';

class DashboardRepository {

  final DashBoardApi api;

  DashboardRepository({
    required this.api,
  });

  Future<TotaisMensaisResponse?> getTotais(DashboardRequestDto filters) {
    return api.getTotais(filters);
  }
}