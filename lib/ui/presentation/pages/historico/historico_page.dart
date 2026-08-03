import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/data/service/export/relatorio_excel.dart';
import 'package:controle_de_gastos_app/ui/data/service/export/relatorio_pdf.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_download.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/cards/card_gasto_historico.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../core/constants/routes/app_routes.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../data/model/gasto.dart';
import '../../../data/service/api/gasto_api.dart';
import '../../widgets/botton_sheet/filtros_gastos_botton_sheet.dart';
import '../../widgets/cards/card_total_gastos.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {

  User? user;
  List<Gasto> listaGastos = [];
  bool _isLoading = true;
  double total = 0;
  final today = DateTime.now();

  late DateTime? _dataInicial = DateTime(today.year, today.month, 1);
  late DateTime? _dataFinal = today;
  StatusPagamentoEnum? _statusPagamento;
  GastoRequestDTO? filtros;

  @override
  void initState() {
    _loadingUser();
    _getGastos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarDownload(
        title: '',
        onBack:  () => Navigator.pop(context),
        //Filter dialog
        onFilter: () async {
          BottomSheetFiltroRelatorio.show(
            context,
            onConfirm: (
                dataInicial,
                dataFinal,
                status,
                ) async {
              setState(() {
                _dataInicial = dataInicial;
                _dataFinal = dataFinal;
                _statusPagamento = status;
              });

              await _getGastos();
            },
          );
        },
        //DownloadPage
        onDownload:  () => Navigator.pushNamed(
          context,
          AppRoutes.relatorio,
          arguments: {
            'filtros': filtros,
          },
        ),
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body: Column(
        children: [
          Utils.sizedBox(altura: 20.0, largura: 0),
          ///Title
          Text("Histórico de Gastos", style: AppTextStyles.textoSentimentoNegritoWhite(20, context),),
          Utils.sizedBox(altura: 20.0, largura: 0),
          ///Total Gastos
          CardTotalGastos(
            total: total,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 50,
                ))
                : ListView.builder(
                    itemCount: listaGastos.length,
                    itemBuilder: (context, index) {
                    final gasto = listaGastos[index];

                    return CardGastoHistorico(gasto: gasto,);
              },
            ),
          ),
        ],
      ),
    );
  }
  //Carregar User
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  //Get Gastos
  Future<void> _getGastos() async {

    setState(() => _isLoading = true);
    filtros = GastoRequestDTO();
    filtros?.deletado = false;
    filtros?.dataInicial = _dataInicial?.toIso8601String();
    filtros?.dataFinal = _dataFinal?.toIso8601String();
    filtros?.statusPagamento = _statusPagamento;

    final gastos = await GastoApi().getListByFilter(filtros!);

    setState(() {
      listaGastos = gastos;
      total = Utils.sumTotalGastos(gastos);
      _isLoading = false;
    });
  }
}