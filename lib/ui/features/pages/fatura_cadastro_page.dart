
import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../data/model/gasto.dart';
import '../../data/model/user.dart';
import 'components/inputs/descricao_field.dart';

class FaturaCadastroPage extends StatefulWidget {
  const FaturaCadastroPage({super.key});

  @override
  State<FaturaCadastroPage> createState() => _FaturaCadastroPageState();
}

class _FaturaCadastroPageState extends State<FaturaCadastroPage> {

  Gasto? gasto;
  User? user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerDescricao = TextEditingController();
  late FocusNode _focusDescricaoNode;

  @override
  void initState() {
    super.initState();
    _initFocus();
    _loadingUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DescricaoField(
                  controller: _controllerDescricao,
                  focusNode: _focusDescricaoNode,
                  hintText: 'Descrição',
                  icon: Icons.money,

                ),
              ],
            ),
          )
          ),
    );
  }

  Future _initPage() async{
    if (gasto == null) {
      final g = ModalRoute.of(context)!.settings.arguments as Gasto?;
      setState(() {
        gasto = g;
        _LoadingEdit(gasto);
      });
    }
  }
_LoadingEdit(Gasto? gasto){
  _controllerDescricao.text  = gasto?.descricao ?? "";
}

  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u!;
      });
    print(user);
  }

  _initFocus(){
    _focusDescricaoNode = FocusNode();
  }
}
