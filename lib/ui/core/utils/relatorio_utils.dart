import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class RelatorioUtils {

  static Future<void> criarExcelAvancado() async {

    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    /// Texto
    final Range rangeTitle = sheet.getRangeByName('A1:C1');

    rangeTitle.setText('Relatório de Gastos');
    rangeTitle.cellStyle.fontSize = 18;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.merge();

    /// Fórmula
    sheet.getRangeByName('B2').setNumber(100);

    final Range range2 = sheet.getRangeByName('B3');
range2.setNumber(200);
range2.numberFormat = r'$#,##0.00';
//range2.st
    sheet.getRangeByName('B4').setFormula('=SUM(B1:B2)');

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