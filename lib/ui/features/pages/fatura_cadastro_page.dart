
import 'dart:convert';

import 'package:controle_de_gastos_app/ui/core/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/appbar/app_bar_cadastro_gasto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/gradients/app_gradients.dart';
import '../../core/utils/utils.dart';
import '../../data/model/gasto.dart';
import '../../data/model/user.dart';
import 'components/data/custom_date_picker_field.dart';
import 'components/inputs/custom_field.dart';
import 'components/inputs/descricao_field.dart';

class FaturaCadastroPage extends StatefulWidget {
  final Gasto? gasto;
  const FaturaCadastroPage({super.key, this.gasto});

  @override
  State<FaturaCadastroPage> createState() => _FaturaCadastroPageState();
}

class _FaturaCadastroPageState extends State<FaturaCadastroPage> {

  ///Variables
  User? user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerDescricao = TextEditingController();
  final _controllerValor = TextEditingController();
  final _controllerVencimento = TextEditingController();
  late FocusNode _focusDescricaoNode;
  late FocusNode _focusValorNode;
  Gasto? gasto;

  @override
  void initState() {
    super.initState();
    _initFocus();
    _loadingUser();
    _loadingGasto();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBarCadastroGasto(
        title: '',
        onBack: () {
          // ação personalizada para voltar
        },
        onClose: () {
          // ação personalizada para fechar
        }, gradient: AppGradients.cadastroPet,
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
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  Text("Cadastre seu Gasto",
                      style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  // Descrição
                  CustomField(
                    controller: _controllerDescricao,
                    focusNode: _focusDescricaoNode,
                    hintText: 'Descrição',
                    icon: Icons.money,
                    keyboardType: TextInputType.text,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  // Valor
                  CustomField(
                    controller: _controllerValor,
                    focusNode: _focusValorNode,
                    hintText: "Digite o valor",
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  // Data Vencimento
                  CustomDatePickerField(
                    label: "Vencimento",
                    initialDate: gasto?.vencimento != null
                        ? DateTime.tryParse(gasto!.vencimento!) ?? DateTime.now()
                        : DateTime.now(),
                    onDateSelected: (date) {
                      print("Data escolhida: $date");
                      _controllerVencimento.text = DateFormat('dd/MM/yyyy').format(date);
                    },
                  ),
                ],
              ),
            ),
          )
          ),
    );
  }

  ///****** METHODS ******

  void _loadingGasto() {
    gasto = widget.gasto;
    if (gasto != null) {
      _controllerDescricao.text = gasto?.descricao ?? "";
      _controllerValor.text = gasto?.valor != null ? gasto!.valor!.toStringAsFixed(2) : "";
      //Vencimento
      if (gasto!.vencimento != null && gasto!.vencimento!.isNotEmpty) {
        try {
          DateTime vencimentoDate = DateTime.tryParse(gasto!.vencimento!) ?? DateTime.now();
          _controllerVencimento.text = DateFormat('dd/MM/yyyy').format(vencimentoDate);
        } catch (e) {
          _controllerVencimento.text = gasto!.vencimento!; // fallback
        }
      }
    } else {
      _clearControllers();
    }
  }

  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u!;
      });
  }

  void _initFocus(){
    _focusDescricaoNode = FocusNode();
    _focusValorNode = FocusNode();
  }
  void _clearControllers(){
    _controllerDescricao.text = '';
    _controllerValor.text = '';
    _controllerVencimento.text = '';
  }
}
