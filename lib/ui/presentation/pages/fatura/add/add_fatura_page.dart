import 'dart:io';

import 'package:controle_de_gastos_app/ui/data/repositories/gasto_repository.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/gasto_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';

import '../../../../core/theme/provider/theme_provider.dart';
import '../../../../core/theme/styles/app_text_styles.dart';
import '../../../../core/utils/utils.dart';
import '../../../widgets/appbar/app_bar_back.dart';
import '../../../widgets/buttons/normal_button/custom_button.dart';
import '../../../widgets/buttons/switch_button/custom_switch_button.dart';
import '../../../widgets/data/custom_date_picker_field.dart';
import '../../../widgets/images/photo_gallery_img.dart';
import '../../../widgets/inputs/custom_field.dart';
import 'add_fatura_view_model.dart';

class AddFaturaPage extends StatelessWidget {
  final Gasto? gasto;

  const AddFaturaPage({
    super.key,
    this.gasto,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddFaturaViewModel(
        gasto: gasto, gastoRepository: GastoRepository(api: GastoApi()),
      )..init(),
      child: const _AddFaturaView(),
    );
  }
}

class _AddFaturaView extends StatefulWidget {
  const _AddFaturaView();

  @override
  State<_AddFaturaView> createState() => _AddFaturaViewState();
}

class _AddFaturaViewState extends State<_AddFaturaView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerVencimento =  TextEditingController();
  late FocusNode _focusDescricaoNode;
  late FocusNode _focusValorNode;
  late DateTime _selectedVencimento;

  @override
  void initState() {
    super.initState();

    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();
    final viewModel = context.read<AddFaturaViewModel>();
    _loadingGasto(viewModel);
  }

  // Carregar dados do gasto
  void _loadingGasto(AddFaturaViewModel viewModel) {
    final gasto = viewModel.gasto;

    _selectedVencimento = gasto?.vencimento != null
        ? DateTime.tryParse(gasto!.vencimento!) ??
        DateTime.now()
        : DateTime.now();

    _controllerDescricao.text = gasto?.descricao ?? "";
    _controllerValor.text = gasto?.valor != null
        ? gasto!.valor!.toStringAsFixed(2)
        : "";

    if (gasto?.vencimento != null &&
        gasto!.vencimento!.isNotEmpty) {
      _controllerVencimento.text =
          DateFormat('dd/MM/yyyy').format(
            _selectedVencimento,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddFaturaViewModel>();

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: context.watch<ThemeProvider>().currentGradient,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                Text(
                  viewModel.isEdit
                      ? "Editar Gasto"
                      : "Cadastre seu Gasto",
                  style: AppTextStyles
                      .textoSentimentoNegritoWhite(
                    20,
                    context,
                  ),
                ),

                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                // Descrição
                CustomField(
                  controller: _controllerDescricao,
                  focusNode: _focusDescricaoNode,
                  hintText: 'Descrição',
                  icon: Icons.money,
                  keyboardType: TextInputType.text,
                ),

                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                // Valor
                CustomField(
                  controller: _controllerValor,
                  focusNode: _focusValorNode,
                  hintText: "Digite o valor",
                  icon: Icons.monetization_on_outlined,
                  keyboardType: TextInputType.number,
                ),

                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                // Vencimento
                CustomDatePickerField(
                  label: "Vencimento",
                  initialDate: _selectedVencimento,
                  onDateSelected: (date) {
                    _selectedVencimento = date;

                    _controllerVencimento.text =
                        DateFormat('dd/MM/yyyy')
                            .format(date);
                  },
                ),

                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                // Pago
                CustomSwitchButton(
                  value: viewModel.isPago,
                  onToggle: viewModel.setPago,
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                ),

                // Foto / Galeria
                ValueListenableBuilder<File?>(
                  valueListenable: Utils.imageShareNotifier,
                  builder: (context, file, _) {
                    return PhotoGalleryNetworkImg(
                      tirarFoto: viewModel.tirarFoto,
                      getImage: viewModel.getImage,
                      imagem: file ?? viewModel.imagem,
                    );
                  },
                ),

                Utils.sizedBox(
                  altura: 20.0,
                  largura: 0,
                ),

                // Salvar
                CustomButton(
                  radios: 20,
                  height: 55,
                  gradient: context
                      .watch<ThemeProvider>()
                      .currentGradient,
                  icon: Icons.monetization_on,
                  isLoading: viewModel.isLoading,
                  onTap: () => _salvarGasto(viewModel),
                  label: 'Salvar',
                  textStyle: AppTextStyles.textLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Salvar gasto
  Future<void> _salvarGasto(
      AddFaturaViewModel viewModel,
      ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sucesso = await viewModel.salvarGasto(
      descricao: _controllerDescricao.text,
      valor: _controllerValor.text,
      vencimento: _selectedVencimento,
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ??
                'Erro ao cadastrar o gasto',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controllerDescricao.dispose();
    _controllerValor.dispose();
    _controllerVencimento.dispose();
    _focusDescricaoNode.dispose();
    _focusValorNode.dispose();

    super.dispose();
  }
}