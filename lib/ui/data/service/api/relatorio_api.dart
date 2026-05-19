import 'dart:io';

import 'package:controle_de_gastos_app/ui/core/configs/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/core/constants/enums/app_platform.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/gasto_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
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

      ///Gerar File
      await generateFile(response);

    } catch (e) {
      print(e);
    }
  }

  Future<void> generateFile(Response res) async {

    AppPlatform platform = Utils.getCurrentPlatform();
    /// ANDROID
    if(platform == AppPlatform.android) {
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists())  await directory.create(recursive: true);

      final filePath = '${directory.path}/relatorio_gastos.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(List<int>.from(res.data),);
      print(filePath);
      await OpenFilex.open(filePath);
    }else
    /// WEB
    if(platform == AppPlatform.web){
        final bytes = Uint8List.fromList(List<int>.from(res.data),);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
        html.AnchorElement(href: url)
          ..setAttribute(
            "download",
            "relatorio_gastos.xlsx",
          )
          ..click();
        html.Url.revokeObjectUrl(url);
      }
    }
  }
