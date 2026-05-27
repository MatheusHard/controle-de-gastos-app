import 'dart:io';
import 'package:controle_de_gastos_app/ui/core/constants/colors/string_colors.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class RelatorioExcel {

  static Future<void> gerarExcelGastos(List<Gasto> listaGastos) async {

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
    rangeDescr.cellStyle.hAlign = HAlignType.center;
    rangeDescr.cellStyle.vAlign = VAlignType.center;
    rangeDescr.setText("Descrição");
    //Vencimento
    final rangeVenc = sheet.getRangeByName('B$cont');
    rangeVenc.cellStyle.hAlign = HAlignType.center;
    rangeVenc.cellStyle.vAlign = VAlignType.center;
    rangeVenc.setText("Vencimento");
    //Valor
    final rangeValor = sheet.getRangeByName('C$cont');
    rangeValor.cellStyle.hAlign = HAlignType.center;
    rangeValor.cellStyle.vAlign = VAlignType.center;
    rangeValor.setText("Valor");
    //Status
    final rangeStatus = sheet.getRangeByName('D$cont');
    rangeStatus.cellStyle.hAlign = HAlignType.center;
    rangeStatus.cellStyle.vAlign = VAlignType.center;
    rangeStatus.setText("Status");
    //Styles
    final headers = sheet.getRangeByName('A$cont:D$cont');
    headers.cellStyle.bold = true;
    headers.cellStyle.borders.all.lineStyle = LineStyle.thin;
    headers.cellStyle.backColor = StringColors.cinza_claro;
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
      itemDescr.columnWidth = 15;

      //Vencimento item
      final itemVenc = sheet.getRangeByName('B$cont');
      itemVenc.setText(Utils.formatarData(item.vencimento, true));
      itemVenc.cellStyle.hAlign = HAlignType.center;
      itemVenc.cellStyle.vAlign = VAlignType.center;
      itemVenc.cellStyle.borders.all.lineStyle = LineStyle.thin;
      itemVenc.columnWidth = 11;
      //Valor item
      final itemValor = sheet.getRangeByName('C$cont');
      itemValor.setText(Utils.formatMoeda(item.valor));
      itemValor.cellStyle.hAlign = HAlignType.center;
      itemValor.cellStyle.vAlign = VAlignType.center;
      itemValor.cellStyle.borders.all.lineStyle = LineStyle.thin;
      itemValor.columnWidth = 10;
      //Status item
      final itemStatus = sheet.getRangeByName('D$cont');
      itemStatus.setText(Utils.formatStatus(item.statusPagamento));
      itemStatus.cellStyle.hAlign = HAlignType.center;
      itemStatus.cellStyle.vAlign = VAlignType.center;
      itemStatus.cellStyle.borders.all.lineStyle = LineStyle.thin;

      cont++;
    }
    ///Footer
    final total = sheet.getRangeByName('A$cont');
    total.setText("TOTAL");
    total.cellStyle.hAlign = HAlignType.center;
    total.cellStyle.vAlign = VAlignType.center;
    total.cellStyle.borders.all.lineStyle = LineStyle.thin;
    total.cellStyle.backColor = StringColors.cinza_claro;

    final vazio = sheet.getRangeByName('B$cont');
    vazio.setText("");
    vazio.cellStyle.hAlign = HAlignType.center;
    vazio.cellStyle.vAlign = VAlignType.center;
    vazio.cellStyle.borders.all.lineStyle = LineStyle.thin;
    vazio.cellStyle.backColor = StringColors.cinza_claro;

    // Valor Total
    double valorTotal = listaGastos.fold(0.0, (soma, item) => soma + (item.valor ?? 0),);
    final itemValorTotal = sheet.getRangeByName('C$cont');
    itemValorTotal.setText(Utils.formatMoeda(valorTotal));
    itemValorTotal.cellStyle.hAlign = HAlignType.center;
    itemValorTotal.cellStyle.vAlign = VAlignType.center;
    itemValorTotal.cellStyle.borders.all.lineStyle = LineStyle.thin;
    itemValorTotal.cellStyle.backColor = StringColors.cinza_claro;

    /// Gerar bytes
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) await directory.create(recursive: true);

    final filePath = '${directory.path}/relatorio_gastos_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    await OpenFilex.open(filePath);
  }
}