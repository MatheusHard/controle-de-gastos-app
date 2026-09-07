import 'package:controle_de_gastos_app/ui/data/repositories/gasto_repository.dart';
import 'package:controle_de_gastos_app/ui/data/service/api/gasto_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/core/theme/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';

import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/buttons/normal_button/custom_button.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/buttons/switch_button/custom_switch_button.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/data/custom_date_picker_field.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/images/photo_gallery_img.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/inputs/custom_field.dart';

import 'edit_fatura_view_model.dart';

class EditFaturaPage extends StatelessWidget {
  final Gasto? gasto;

  const EditFaturaPage({
    super.key,
    this.gasto,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditFaturaViewModel(
        gasto: gasto,
        gastoRepository: GastoRepository(api: GastoApi())
      )..init(),
      child: const _EditFaturaView(),
    );
  }
}

class _EditFaturaView extends StatefulWidget {
  const _EditFaturaView();

  @override
  State<_EditFaturaView> createState() => _EditFaturaViewState();
}

class _EditFaturaViewState extends State<_EditFaturaView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerVencimento = TextEditingController();
  late FocusNode _focusDescricaoNode;
  late FocusNode _focusValorNode;
  DateTime _selectedVencimento = DateTime.now();

  @override
  void initState() {
    super.initState();

    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();

    final viewModel = context.read<EditFaturaViewModel>();

    _loadingFields(viewModel);
  }

  void _loadingFields(EditFaturaViewModel viewModel) {
    final gasto = viewModel.gasto;

    if (gasto == null) {
      return;
    }

    _selectedVencimento = Utils.parseVencimento(
      gasto.vencimento,
    );

    _controllerDescricao.text = gasto.descricao ?? '';

    _controllerValor.text = gasto.valor != null
        ? gasto.valor!.toStringAsFixed(2)
        : '';

    if (gasto.vencimento != null &&
        gasto.vencimento!.isNotEmpty) {
      _controllerVencimento.text =
          DateFormat('dd/MM/yyyy').format(
            _selectedVencimento,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditFaturaViewModel>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: themeProvider.currentGradient,
      ),
      body: _buildBody(
        context,
        viewModel,
        themeProvider,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      EditFaturaViewModel viewModel,
      ThemeProvider themeProvider,
      ) {
    if (viewModel.errorMessage != null &&
        viewModel.gasto == null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: AppTextStyles.textoSentimentoNegritoWhite(
            16,
            context,
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              Text(
                'Atualize seu Gasto',
                style:
                AppTextStyles.textoSentimentoNegritoWhite(
                  20,
                  context,
                ),
              ),

              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              CustomField(
                controller: _controllerDescricao,
                focusNode: _focusDescricaoNode,
                hintText: 'Descrição',
                icon: Icons.money,
                keyboardType: TextInputType.text,
              ),

              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              CustomField(
                controller: _controllerValor,
                focusNode: _focusValorNode,
                hintText: 'Digite o valor',
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
              ),

              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              CustomDatePickerField(
                label: 'Vencimento',
                initialDate: _selectedVencimento,
                onDateSelected: (date) {
                  setState(() {
                    _selectedVencimento = date;

                    _controllerVencimento.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  });
                },
              ),

              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              CustomSwitchButton(
                value: viewModel.isPago,
                onToggle: viewModel.setPago,
                activeColor: Colors.green,
                inactiveColor: Colors.red,
              ),

              PhotoGalleryNetworkImg(
                tirarFoto: viewModel.tirarFoto,
                getImage: viewModel.getImage,
                imagem: viewModel.imagem,
                url: viewModel.photoGalleryUrl,
              ),

              Utils.sizedBox(
                altura: 20,
                largura: 0,
              ),

              CustomButton(
                radios: 20,
                height: 55,
                gradient: themeProvider.currentGradient,
                icon: Icons.monetization_on,
                isLoading: viewModel.isLoading,
                onTap: () => _salvarGasto(
                  context,
                  viewModel,
                ),
                label: 'Salvar',
                textStyle: AppTextStyles.textLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarGasto(
      BuildContext context,
      EditFaturaViewModel viewModel,
      ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sucesso = await viewModel.salvarGasto(
      descricao: _controllerDescricao.text.trim(),
      valor: _controllerValor.text.trim(),
      vencimento: _selectedVencimento,
    );

    if (!context.mounted) {
      return;
    }

    if (sucesso) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          viewModel.errorMessage ??
              'Não foi possível atualizar o gasto.',
        ),
      ),
    );
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