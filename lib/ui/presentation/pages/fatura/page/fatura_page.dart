import 'package:controle_de_gastos_app/ui/data/repositories/agenda_de_pagamento_repository.dart';
import 'package:controle_de_gastos_app/ui/data/repositories/gasto_repository.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/agenda_de_pagamento_api.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/gasto_api.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../../core/constants/routes/app_routes.dart';
import '../../../../data/model/gasto.dart';
import '../../../widgets/appbar/app_bar_usuario.dart';
import '../../../widgets/buttons/floating_action_button/custom_floating_action_button.dart';
import '../../../widgets/cards/card_gasto.dart';
import 'fatura_view_model.dart';

class FaturaPage extends StatelessWidget {
  const FaturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FaturaViewModel(
          gastoRepository: GastoRepository(api: GastoApi()),
          agendaDePagamentoRepository: AgendaDePagamentoRepository(api: AgendaDePagamentoApi()))
        ..init(),
      child: const _FaturaView(),
    );
  }
}

class _FaturaView extends StatelessWidget {
  const _FaturaView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FaturaViewModel>();

    return Scaffold(
      appBar: AppBarUser(
        viewModel.user,
        "",
        context,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(context, viewModel),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _adicionarGasto(context, viewModel),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      FaturaViewModel viewModel,
      ) {
    if (viewModel.isLoading) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.blue,
          size: 50,
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(viewModel.errorMessage!),
      );
    }

    if (viewModel.listaGastos.isEmpty) {
      return const Center(
        child: Text('Nenhum gasto encontrado.'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: viewModel.listaGastos.length,
      itemBuilder: (context, index) {
        final gasto = viewModel.listaGastos[index];

        return Dismissible(
          key: ValueKey(gasto.id),
          direction: DismissDirection.endToStart,

          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),

          onDismissed: (_) async {
            final sucesso = await viewModel.deletarGasto(gasto);

            if (sucesso && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${gasto.descricao} removida",
                  ),
                ),
              );
            }
          },

          child: CardGastoItem(
            icon: Icons.receipt_long,
            label: gasto.descricao ?? "Sem nome",
            onTap: () => _editarGasto(
              context,
              viewModel,
              gasto,
            ),

            statusPagamento:
            gasto.statusPagamento ??
                StatusPagamentoEnum.NAO_PAGO,
          ),
        );
      },
    );
  }

  // Adicionar gasto
  Future<void> _adicionarGasto(
      BuildContext context,
      FaturaViewModel viewModel,
      ) async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.add_fatura,
      arguments: {
        'gasto': Gasto(
          agendaDePagamento: viewModel.faturaAtual,
        ),
      },
    );

    if (resultado == true && context.mounted) {
      await viewModel.refresh();
    }
  }

  // Editar gasto
  Future<void> _editarGasto(
      BuildContext context,
      FaturaViewModel viewModel,
      gasto,
      ) async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.edit_fatura,
      arguments: {
        'gasto': gasto,
      },
    );

    if (resultado == true && context.mounted) {
      await viewModel.refresh();
    }
  }
}