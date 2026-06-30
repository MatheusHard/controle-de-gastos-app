import 'package:controle_de_gastos_app/ui/core/configs/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/gasto_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';

class RelatorioApi {

  BuildContext? _context;

  RelatorioApi(BuildContext context){
    _context = context;
  }

  Future<void> getRelatorioGastos(GastoDTO filtros) async {
    final configs = await Configs.create();
    //Remove filtros nulos
    final params = filtros.toJson()..removeWhere((key, value) => value == null);

    try {
      final response = await configs.dio.get(
        "/relatorio/gastos/excel",
        queryParameters: params,
        options: Options(
          responseType: ResponseType.bytes,
          headers: await Utils.requestToken(),
        ),
      );
      await Utils.generateFile(response, "relatorio_gastos");
    } catch (e) {
      print(e);
    }
  }
}