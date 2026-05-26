import 'dart:io';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class RelatorioUtils {

  static Future<void> criarExcelAvancado(List<Gasto> listaGastos) async {

    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    /// Title
    final Range rangeTitle = sheet.getRangeByName('A1:D1');
    rangeTitle.setText('Relatório de Gastos');
    rangeTitle.cellStyle.fontSize = 18;
    rangeTitle.cellStyle.bold = true;
    rangeTitle.merge();

    int cont = 2;
    ///****HEADERS****
    // Descrição
    final rangeDescr = sheet.getRangeByName('A$cont');
    rangeDescr.setText("Descrição");
    //Vencimento
    final rangeVenc = sheet.getRangeByName('B$cont');
    rangeVenc.setText("Vencimento");
    //Valor
    final rangeValor = sheet.getRangeByName('C$cont');
    rangeValor.setText("Valor");
    //Status
    final rangeStatus = sheet.getRangeByName('D$cont');
    rangeStatus.setText("Status");
    //Styles
    final headers = sheet.getRangeByName('A$cont:D$cont');
    headers.cellStyle.bold = true;
    headers.cellStyle.borders.all.lineStyle = LineStyle.thin;
    headers.cellStyle.backColor = '#d2d2ce';

    rangeTitle.cellStyle.bold = true;
    rangeTitle.cellStyle.hAlign = HAlignType.center;
    rangeTitle.cellStyle.vAlign = VAlignType.center;
    rangeTitle.cellStyle.borders.all.lineStyle = LineStyle.thin;
    //headers.cellStyle.borders.all.color = '#000000';
    cont++;
    for(Gasto item in listaGastos) {
      //Descri item
      final itemDescr = sheet.getRangeByName('A$cont');
      itemDescr.setText(item.descricao);
      itemDescr.cellStyle.hAlign = HAlignType.center;
      itemDescr.cellStyle.vAlign = VAlignType.center;
      itemDescr.cellStyle.borders.all.lineStyle = LineStyle.thin;
      //Vencimento item
      final itemVenc = sheet.getRangeByName('B$cont');
      itemVenc.setText(Utils.formatarData(item.vencimento, true));
      itemVenc.cellStyle.hAlign = HAlignType.center;
      itemVenc.cellStyle.vAlign = VAlignType.center;
      itemVenc.cellStyle.borders.all.lineStyle = LineStyle.thin;
      //Valor item
      final itemVAlor = sheet.getRangeByName('C$cont');
      itemVAlor.setText(Utils.formatMoeda(item.valor));
      itemVAlor.cellStyle.hAlign = HAlignType.center;
      itemVAlor.cellStyle.vAlign = VAlignType.center;
      itemVAlor.cellStyle.borders.all.lineStyle = LineStyle.thin;
      //Status item
      final itemStatus = sheet.getRangeByName('D$cont');
      itemStatus.setText(Utils.formatStatus(item.statusPagamento));
      itemStatus.cellStyle.hAlign = HAlignType.center;
      itemStatus.cellStyle.vAlign = VAlignType.center;
      itemStatus.cellStyle.borders.all.lineStyle = LineStyle.thin;

      cont++;
    }
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