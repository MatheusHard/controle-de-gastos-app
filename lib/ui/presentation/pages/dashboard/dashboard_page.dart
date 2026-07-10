import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/dashboarding/totais_mensais_response.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/gasto_dto.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/user_dto.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/dashboard_api.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/cards/card_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dtos/dashboarding/gastos_data.dart';
import '../../../data/dtos/dashboarding/gastos_mensais.dart';
import '../../../data/dtos/request/dashboard_request_dto.dart';
import '../../../data/model/user.dart';
import '../../widgets/cards/card_total_gastos.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  
  User? user;
  late TotaisMensaisResponse dashboardObject;
  late List<GastosMensais>? listaMensal = [];
  late double? totaGeral = 0;
  bool _isLoading = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: ()  => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body: _isLoading
          ? Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blue,
            size: 50,
          ))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Utils.sizedBox(altura: 20.0, largura: 0),
              Text("DashBoarding",style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),

              ///Gráfico por mês
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$'),
                ),
                title: ChartTitle(text: 'Gastos mensais'),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'Mês: point.x\nValor: R\$ point.y',
                ),
                series: <LineSeries<GastosMensais, String>>[
                  LineSeries<GastosMensais, String>(
                    dataSource: listaMensal,
                    xValueMapper: (GastosMensais gastos, _) => gastos.mesAbreviado,
                    yValueMapper: (GastosMensais gastos, _) => gastos.total,
                    name: 'Gastos',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
              ///Card Total
              CardDashboard(title: 'Total Geral',value: totaGeral, icon: Icons.monetization_on_sharp,)
            ],
          ),
        ),
      )
    );
  }
  Future<void> _init() async {
    await _loadingUser();
    await _loadDashBoarding();
  }

  Future<void> _loadDashBoarding() async {
    setState(() {
      _isLoading = true;
    });

    final filters = DashboardRequestDto()
      ..deletado = false
      ..userId = user!.id;

    dashboardObject = (await DashBoardApi().getTotais(filters))!;

    setState(() {
      listaMensal = dashboardObject.totaisPorMes;
      totaGeral = dashboardObject.somaTotal;
      _isLoading = false;
    });
  }
  //Carregar User
  Future<void> _loadingUser() async {
    user = await Utils.recuperarUser();
  }

}



