import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_download.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/cards/card_gasto_historico.dart';

import '../../../core/constants/routes/app_routes.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../widgets/botton_sheet/filtros_gastos_botton_sheet.dart';
import '../../widgets/cards/card_total_gastos.dart';
import 'historico_view_model.dart';

/// View: só monta a árvore de widgets e delega toda a lógica ao
/// HistoricoViewModel. Não guarda estado próprio nem chama a API.
class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoricoViewModel()..initialize(),
      child: const _HistoricoView(),
    );
  }
}

class _HistoricoView extends StatelessWidget {
  const _HistoricoView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HistoricoViewModel>();

    return Scaffold(
      appBar: AppBarDownload(
        title: '',
        onBack: () => Navigator.pop(context),
        // Filter dialog
        onFilter: () async {
          BottomSheetFiltroRelatorio.show(
            context,
            onConfirm: (dataInicial, dataFinal, status, descricao) async {
              await viewModel.aplicarFiltros(
                dataInicial: dataInicial,
                dataFinal: dataFinal,
                status: status,
                descricao: descricao,
              );
            },
          );
        },
        // Download Page
        onDownload: () => Navigator.pushNamed(
          context,
          AppRoutes.relatorio,
          arguments: {
            'filtros': viewModel.filtros,
          },
        ),
        gradient: context.watch<ThemeProvider>().currentGradient,
      ),
      body: Column(
        children: [
          Utils.sizedBox(altura: 20.0, largura: 0),
          // Title
          Text(
            "Histórico de Gastos",
            style: AppTextStyles.textoSentimentoNegritoWhite(20, context),
          ),
          Utils.sizedBox(altura: 20.0, largura: 0),
          // Total Gastos
          CardTotalGastos(total: viewModel.total),
          const SizedBox(height: 8),
          Expanded(
            child: viewModel.isLoading
                ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: 50,
              ),
            )
                : ListView.builder(
              itemCount: viewModel.listaGastos.length,
              itemBuilder: (context, index) {
                final gasto = viewModel.listaGastos[index];
                return CardGastoHistorico(gasto: gasto);
              },
            ),
          ),
        ],
      ),
    );
  }
}
