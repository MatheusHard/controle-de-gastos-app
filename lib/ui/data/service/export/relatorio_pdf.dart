import 'dart:io';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioPdf {

  static Future<void> gerarPdfGastos(List<Gasto> listaGastos) async {

    final pdf = pw.Document();

    double valorTotal = listaGastos.fold(0.0, (soma, item) => soma + (item.valor ?? 0),);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Text(
          'Relatório de Gastos',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: [
              'Descrição',
              'Vencimento',
              'Valor',
              'Status',
            ],
            data: listaGastos.map(
                  (item) => [
                item.descricao ?? '',
                Utils.formatarData(item.vencimento, true),
                Utils.formatMoeda(item.valor),
                Utils.formatStatus(item.statusPagamento),
              ],
            ).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total: ${Utils.formatMoeda(valorTotal)}',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath =
        '${directory.path}/relatorio_gastos_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(filePath);
  }
}