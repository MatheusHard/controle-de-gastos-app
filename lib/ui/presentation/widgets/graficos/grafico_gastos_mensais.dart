import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/dtos/dashboarding/gastos_mensais.dart';

class GraficoGastosMensais extends StatelessWidget {
  final List<GastosMensais>? gastos;

  const GraficoGastosMensais({
    super.key,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    final lista = gastos ?? [];

    final largura = lista.length * 100.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: largura < 600 ? 600 : largura,
        height: 350,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),

          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.currency(
              locale: 'pt_BR',
              symbol: 'R\$',
            ),
          ),

          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'Mês: point.x\nValor: R\$ point.y',
          ),

          series: <LineSeries<GastosMensais, String>>[
            LineSeries<GastosMensais, String>(
              dataSource: lista,

              xValueMapper: (GastosMensais gasto, _) =>
              gasto.mesAbreviado,

              yValueMapper: (GastosMensais gasto, _) =>
              gasto.total,

              name: 'Gastos',

              markerSettings: const MarkerSettings(
                isVisible: true,
              ),

              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}