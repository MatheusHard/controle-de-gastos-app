
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../data/model/gasto.dart';
import '../../data/model/user.dart';
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
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DescricaoField(
                    controller: _controllerDescricao,
                    focusNode: _focusDescricaoNode,
                    hintText: 'Descrição',
                    icon: Icons.money,
                    ),
                ],
              ),
            ),
          )
          ),
    );
  }

  ///****** METHODS ******

  void _loadingGasto(){
    gasto = widget.gasto;
    if (gasto != null) {
      print( gasto!.statusPagamento);
      _controllerDescricao.text = gasto?.descricao ?? "";
      _controllerValor.text = (gasto?.valor != null ? gasto?.valor?.toStringAsFixed(2) : "")!;
      _controllerVencimento.text = gasto!.vencimento.toString();
    }else{
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
