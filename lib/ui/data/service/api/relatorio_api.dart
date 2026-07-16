import 'package:controle_de_gastos_app/ui/core/configs/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/core/constants/enums/type_file_enum.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/gasto_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../dtos/request/get/gasto_request_dto.dart';

class RelatorioApi {

  BuildContext? _context;

  RelatorioApi(BuildContext context){
    _context = context;
  }

  Future<void> getRelatorioGastosExcel(GastoRequestDTO filtros) async {
    final configs = await Configs.create();
    //Remove filtros nulos
    //final params = filtros.toJson()..removeWhere((key, value) => value == null);

    try {
      final response = await configs.dio.get(
        "/relatorio/gastos/excel",
        queryParameters:  filtros.toJson(),
        options: Options(
          responseType: ResponseType.bytes,
          headers: await Utils.requestToken(),
        ),
      );
      //
      await Utils.generateFile(
        response,
        "relatorio_gastos",
        extension: TypeFileEnum.excel,
      );
    } catch (e) {
      print(e);
    }
  }
  Future<void> getRelatorioGastosPdf(GastoRequestDTO filtros) async {
    final configs = await Configs.create();

    try {
      final response = await configs.dio.get(
        "/relatorio/gastos/pdf",
        queryParameters: filtros.toJson(),
        options: Options(
          responseType: ResponseType.bytes,
          headers: await Utils.requestToken(),
        ),
      );

      await Utils.generateFile(
        response,
        "relatorio_gastos",
        extension: TypeFileEnum.pdf,
      );
    } catch (e) {
      print(e);
    }
  }
}