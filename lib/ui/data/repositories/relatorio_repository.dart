import 'package:flutter/material.dart';

import '../dtos/request/get/email_request_dto.dart';
import '../dtos/request/get/gasto_request_dto.dart';
import '../service/api/email_api.dart';
import '../service/api/relatorio_api.dart';

class RelatorioRepository {
  final BuildContext context;

  RelatorioRepository(this.context);

  Future<void> baixarExcel(GastoRequestDTO filtros) async {
    await RelatorioApi(context).getRelatorioGastosExcel(filtros);
  }

  Future<void> baixarPdf(GastoRequestDTO filtros) async {
    await RelatorioApi(context).getRelatorioGastosPdf(filtros);
  }

  Future<void> enviarEmail(EmailRequestDTO request) async {
    await EmailApi(context).sendEmail(request);
  }
}