import 'dart:io';

import 'package:controle_de_gastos_app/ui/core/constants/colors/app_colors.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class RelatorioUtils {

  static Future<void> criarExcelAvancado() async {

    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    /// Title
    final Range rangeTitle = sheet.getRangeByName('A1:D1');
    rangeTitle.setText('Relatório de Gastos');
    rangeTitle.cellStyle.fontSize = 18;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.merge();

    /// Headers
    final rangeDescr = sheet.getRangeByName('A2');
    rangeDescr.setText("Descrição");

    final rangeVenc = sheet.getRangeByName('B2');
    rangeVenc.setText("Vencimento");

    final rangeValor = sheet.getRangeByName('C2');
    rangeValor.setText("Valor");

    final rangeStatus = sheet.getRangeByName('D2');
    rangeStatus.setText("Status");

    /// Borders
    final headers = sheet.getRangeByName('A2:D2');
    headers.cellStyle.bold = true;
    headers.cellStyle.borders.all.lineStyle = LineStyle.thin;
    headers.cellStyle.backColor = '#d2d2ce';
    //headers.cellStyle.borders.all.color = '#000000';

    rangeTitle.cellStyle.bold = true;
    rangeTitle.cellStyle.hAlign = HAlignType.center;
    rangeTitle.cellStyle.vAlign = VAlignType.center;
    rangeTitle.cellStyle.borders.all.lineStyle = LineStyle.thin;
    //headers.cellStyle.borders.all.color = '#000000';

    /// Fórmula
    sheet.getRangeByName('B4').setFormula('=SUM(B1:B2)');

    /// Gerar bytes
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) await directory.create(recursive: true);

    final filePath = '${directory.path}/gastos_excel.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    await OpenFilex.open(filePath);

  }
}