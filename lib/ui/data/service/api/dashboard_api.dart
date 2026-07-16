import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/dashboarding/totais_mensais_response.dart';
import 'package:dio/dio.dart';
import '../../../core/configs/dio/configs.dart';
import '../../dtos/request/get/dashboard_request_dto.dart';

class DashBoardApi {

  final URL = "/dashboard";
  final GET_TOTAIS = '/totais-mensais';

  DashBoardApi();

  //Get All By Filters
  Future<TotaisMensaisResponse?> getTotais(DashboardRequestDto filtros) async {
    final configs = await Configs.create();
    var response = await configs.dio.get(
      URL + GET_TOTAIS,
      queryParameters: filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200 && response.data != null && response.data != "") {
      return TotaisMensaisResponse.fromJson(response.data);
    }
    return null;
  }

}