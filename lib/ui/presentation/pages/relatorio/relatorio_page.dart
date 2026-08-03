import 'package:controle_de_gastos_app/ui/core/constants/enums/type_file_enum.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/relatorio_api.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/buttons/radio/radio_type_relatorio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../data/dtos/request/get/gasto_request_dto.dart';
import '../../widgets/buttons/normal_button/custom_button.dart';


class RelatorioPage extends StatefulWidget {
  final GastoRequestDTO? filtros;

  const RelatorioPage({super.key, this.filtros});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {

  TypeFileEnum _selected = TypeFileEnum.pdf;
  bool _isLoading = false;

  GastoRequestDTO? filtros;

  @override
  void initState() {
    filtros = widget.filtros;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack:  () => Navigator.pop(context),
        onClose: () =>  Navigator.pop(context),
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text("Em qual formato você deseja baixar o relatório?",
                style: AppTextStyles.textoSentimentoNegritoWhite(
                    20, context),),

              const SizedBox(height: 30),
              ///Radio Pdf
              RadioTypeRelatorio<TypeFileEnum>(
                value: TypeFileEnum.pdf,
                groupValue: _selected,
                icon: Icons.picture_as_pdf,
                title: "PDF",
                subtitle: "Ideal para visualizar e imprimir",
                onChanged: (value) {
                  setState(() {
                    _selected = value!;
                  });
                },
              ),

              const SizedBox(height: 15),
              ///Radio Excel
              RadioTypeRelatorio<TypeFileEnum>(
                value: TypeFileEnum.excel,
                groupValue: _selected,
                icon: Icons.table_chart,
                title: "Excel (.xlsx)",
                subtitle: "Ideal para editar no Excel",
                onChanged: (value) {
                  setState(() {
                    _selected = value!;
                  });
                },
              ),
              const Spacer(),

              ///Button Baixar
              CustomButton(
                radios: 20,
                height: 55,
                gradient: context
                    .watch<ThemeProvider>()
                    .currentGradient,
                // vem do provider
                icon: Icons.file_download,
                isLoading: _isLoading,
                onTap: () async {
                  switch (_selected) {
                    case TypeFileEnum.pdf:
                     await baixarPdf();
                      break;
                    case TypeFileEnum.excel:
                      await baixarExcel();
                      break;
                    case TypeFileEnum.email:
                    print("baixarExcel()");
                      break;
                  }
                },
                label: 'Baixar',
                textStyle: AppTextStyles.textLogin,
              ),

            ],
          ),
        ),
      ),
    );
  }
  // Gerar Excel
  Future<void> baixarExcel() async {

    setState(() {_isLoading = true;});
   try {
      await RelatorioApi(context).getRelatorioGastosExcel(filtros!);
    } finally {
      if (mounted) {
        setState(() {_isLoading = false;});
      }
    }
  }

  // Gerar Pdf
  Future<void> baixarPdf() async {

    setState(() {_isLoading = true;});
    try {
      await RelatorioApi(context).getRelatorioGastosPdf(filtros!);
    } finally {
      if (mounted) {
        setState(() {_isLoading = false;});
      }
    }
  }
}
