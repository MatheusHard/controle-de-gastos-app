import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class RelatorioUtils {

  static Future<void> criarExcelAvancado() async {

    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    /// Texto
    final Range range = sheet.getRangeByName('A1');

    range.setText('Relatório Financeiro');

    range.cellStyle.fontSize = 14;
    range.cellStyle.bold = true;

    /// Fórmula
    sheet.getRangeByName('B1').setNumber(100);

    sheet.getRangeByName('B2').setNumber(200);

    sheet.getRangeByName('B3').setFormula('=SUM(B1:B2)');

    /// Gerar bytes
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final directory = Directory('/storage/emulated/0/Download');
//    final directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final filePath = '${directory.path}/ffff.xlsx';

    final file = File(filePath);

    await file.writeAsBytes(bytes);

    await OpenFilex.open(filePath);

    print(filePath);
  }
}