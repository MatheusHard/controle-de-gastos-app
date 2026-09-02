import 'package:controle_de_gastos_app/ui/presentation/pages/relatorio/relatorio_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/enums/type_file_enum.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../data/dtos/request/get/gasto_request_dto.dart';
import '../../../data/repositories/relatorio_repository.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/buttons/normal_button/custom_button.dart';
import '../../widgets/buttons/radio/radio_type_relatorio.dart';

class RelatorioPage extends StatelessWidget {
  final GastoRequestDTO? filtros;

  const RelatorioPage({
    super.key,
    this.filtros,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RelatorioViewModel(
          repository: RelatorioRepository(context),
          filtros: filtros,
        ),
      child: const _RelatorioView(),
    );
  }
}

class _RelatorioView extends StatelessWidget {
  const _RelatorioView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RelatorioViewModel>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: themeProvider.currentGradient,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Título
              Text(
                "Em qual formato você deseja baixar o relatório?",
                style: AppTextStyles.textoSentimentoNegritoWhite(
                  20,
                  context,
                ),
              ),

              const SizedBox(height: 30),

              /// PDF
              RadioTypeRelatorio<TypeFileEnum>(
                value: TypeFileEnum.pdf,
                groupValue: viewModel.selected,
                icon: Icons.picture_as_pdf,
                title: "PDF",
                subtitle: "Ideal para visualizar e imprimir",
                onChanged: (value) {
                  if (value != null) {
                    viewModel.selecionarTipo(value);
                  }
                },
              ),

              const SizedBox(height: 15),

              /// Excel
              RadioTypeRelatorio<TypeFileEnum>(
                value: TypeFileEnum.excel,
                groupValue: viewModel.selected,
                icon: Icons.table_chart,
                title: "Excel (.xlsx)",
                subtitle: "Ideal para editar no Excel",
                onChanged: (value) {
                  if (value != null) {
                    viewModel.selecionarTipo(value);
                  }
                },
              ),

              const SizedBox(height: 15),

              /// Email
              RadioTypeRelatorio<TypeFileEnum>(
                value: TypeFileEnum.email,
                groupValue: viewModel.selected,
                icon: Icons.email_outlined,
                title: "Email",
                subtitle: "Ideal para envio de Emails",
                onChanged: (value) {
                  if (value != null) {
                    viewModel.selecionarTipo(value);
                  }
                },
              ),

              const Spacer(),

              /// Botão
              CustomButton(
                radios: 20,
                height: 55,
                gradient: themeProvider.currentGradient,
                icon: Icons.file_download,
                isLoading: viewModel.isLoading,
                onTap: () async {
                  await viewModel.gerarRelatorio();
                },
                label: 'Baixar/Enviar',
                textStyle: AppTextStyles.textLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}