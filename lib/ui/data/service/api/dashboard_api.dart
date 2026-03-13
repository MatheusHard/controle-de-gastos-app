import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/dashboarding/totais_mensais_response.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/dio/configs.dart';
import '../../dtos/gasto_dto.dart';

class DashBoardApi {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = "/dashboard";
  final GET_TOTAIS = '/totais-mensais';


  DashBoardApi(BuildContext context) {
    _context = context;
  }

  //Get All By Filters
  Future<TotaisMensaisResponse?> getTotais(GastoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL + GET_TOTAIS,
      data: filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200 && response.data != null && response.data != "") {
      return TotaisMensaisResponse.fromJson(response.data);
    }
    return null;
  }
}