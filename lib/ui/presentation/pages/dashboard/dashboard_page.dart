import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/service/api/dashboard_api.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/cards/card_dashboard.dart';
import '../../widgets/graficos/grafico_gastos_mensais.dart';
import 'dashboard_view_model.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        repository: DashboardRepository(
          api: DashBoardApi(),
        ),
      )..init(),

      child: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBarBack(
              title: '',
              onBack: () => Navigator.pop(context),
              onClose: () => Navigator.pop(context),
              gradient:
              context
                  .watch<ThemeProvider>()
                  .currentGradient,
            ),

            body: _buildBody(
              context,
              vm,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      DashboardViewModel vm,
      ) {
    // Loading
    if (vm.isLoading) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.blue,
          size: 50,
        ),
      );
    }

    // Erro
    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            Text(
              vm.errorMessage!,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                await vm.refresh();
              },
              child: const Text(
                'Tentar novamente',
              ),
            ),
          ],
        ),
      );
    }

    // Conteúdo
    return RefreshIndicator(
      onRefresh: vm.refresh,

      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),

        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            crossAxisAlignment:
            CrossAxisAlignment.center,

            children: [
              Utils.sizedBox(
                altura: 20.0,
                largura: 0,
              ),

              Text(
                'DashBoarding',
                style: AppTextStyles
                    .textoSentimentoNegritoWhite(
                  20,
                  context,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              /// Gráfico por mês
              GraficoGastosMensais(
                gastos: vm.listaMensal,
              ),

              const SizedBox(
                height: 20,
              ),

              /// Total Geral
              CardDashboard(
                title: 'Total Geral',
                value: vm.totalGeral,
                icon:
                Icons.monetization_on_sharp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}