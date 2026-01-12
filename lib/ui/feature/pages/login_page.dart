import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /// ******* CAMPOS *******
  bool _isManterConectado = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _myFocusNode;
  late String _email;
  late String _senha;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _obscured = true;
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void initState (){
    _loadUser;
    _myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: ListView(
          children: [
            Text("usuario"),
            Utils.sizedBox(altura: 30.0),
            Text("Senha"),
            Utils.sizedBox(altura: 30.0),
            GestureDetector(

            )
          ],
        )

      ),
    );


  }


  ///********  METHODS  *********

  Future<void> _loadUser() async {
    User? user = await Utils.recuperarUser();
    if(user != null){
      _email = user.username ?? "";
      _senha = user.password ?? "";
      _controllerEmail.text = _email;
      _controllerPassword.text = _senha;
    }
    _loadConectado();
  }

  Future<void> _loadConectado() async {
      _isManterConectado = await Utils.recuperarManterConectado();
    setState(() {
      _isManterConectado;
    });
  }
}
