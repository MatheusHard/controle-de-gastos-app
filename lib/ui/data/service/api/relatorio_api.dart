import 'dart:io';

import 'package:controle_de_gastos_app/ui/core/configs/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/gasto_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/login.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/routes/app_routes.dart';
import '../../../core/utils/utils.dart';

class RelatorioApi {

  BuildContext? _context;

  RelatorioApi(BuildContext context){
    _context = context;
  }

  Future<void> getRelatorioGastos(GastoDTO filtros) async {

    final configs = await Configs.create();
    try {

      final response = await configs.dio.post(
        "/relatorio/gastos",
        data: filtros.toJson(),

        options: Options(

          responseType: ResponseType.bytes,
          headers: await Utils.requestToken()
        ),
      );

      final directory = await getApplicationDocumentsDirectory();

      final filePath =
          '${directory.path}/relatorio_gastos.xlsx';

      final file = File(filePath);

      await file.writeAsBytes(response.data);

      print('Arquivo salvo em: $filePath');

      await OpenFilex.open(filePath);

    } catch (e) {
      print(e);
    }
}
}