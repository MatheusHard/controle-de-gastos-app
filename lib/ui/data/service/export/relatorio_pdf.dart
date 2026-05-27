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
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// Título
              pw.Center(
                child: pw.Text(
                  'Relatório de Gastos',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              /// Tabela
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                headers: [
                  'Descrição',
                  'Vencimento',
                  'Valor',
                  'Status',
                ],
                data: [
                  ...listaGastos.map(
                        (item) => [
                      item.descricao ?? '',
                      Utils.formatarData(item.vencimento, true),
                      Utils.formatMoeda(item.valor),
                      Utils.formatStatus(item.statusPagamento),
                    ],
                  ),

                  /// Linha total
                  [
                    'TOTAL',
                    '',
                    Utils.formatMoeda(valorTotal),
                    '',
                  ],
                ],
              ),
            ],
          );
        },
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