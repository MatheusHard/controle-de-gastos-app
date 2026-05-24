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

    try {

      final response = await configs.dio.post(
        "/relatorio/gastos",
        data: filtros.toJson(),
        options: Options(
          responseType: ResponseType.bytes,
          headers: await Utils.requestToken(),
        ),
      );

      //await generateFile(response);

    } catch (e) {
      print(e);
    }
  }

  /*Future<void> generateFile(Response res) async {

    AppPlatform platform = Utils.getCurrentPlatform();

    /// ANDROID
    if(platform == AppPlatform.android) {

      final directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        print("Diretory");
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/relatorio_gastos.xlsx';

      final file = File(filePath);

      await file.writeAsBytes(
        List<int>.from(res.data),
      );

      await OpenFilex.open(filePath);
    }

    /// WEB
    else if(platform == AppPlatform.web){
      downloadFile(
        List<int>.from(res.data),
        "relatorio_gastos.xlsx",
      );
    }
  }*/


}