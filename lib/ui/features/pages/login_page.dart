import 'package:controle_de_gastos_app/ui/core/imgs/img_url.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/buttons/login_button.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/images/logo_img.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/inputs/email_field.dart';
import 'package:controle_de_gastos_app/ui/service/api/login_api.dart';
import 'package:flutter/material.dart';

import '../../core/gradients/app_gradients.dart';
import '../../core/styles/app_text_styles.dart';
import 'components/inputs/password_field.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /// ******* CAMPOS *******
  bool _isManterConectado = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _focusEmailNode;
  late FocusNode _focusPaswordNode;
  late String _email;
  late String _senha;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  bool _obscured = true;
  bool _isLoading = false;

  @override
  void initState (){
    _loadUser();
    _focusEmailNode = FocusNode();
    _focusPaswordNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // Limita a largura para centralizar melhor
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LogoImg(width: MediaQuery.of(context).size.width, tamanho: 3, url: ImgUrl.zap,),

                  Utils.sizedBox(altura: 30.0),

                  /// Email
                  EmailField(
                    controller: _controllerEmail,
                    focusNode: _focusEmailNode,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),

                  /// Password
                  PasswordField(
                    controller: _controllerPassword,
                    focusNode: _focusPaswordNode,
                    obscured: _obscured,
                    onToggleObscured: _toggleObscured,
                    onChanged: (value) {
                      setState(() {
                        _senha = value;
                      });
                    },
                  ),

                  /// Botão de login
                  LoginButton(
                    onTap: _handleLogin,
                    isLoading: _isLoading,
                    label: "Acessar",
                    icon: Icons.account_circle_rounded,
                    gradient: AppGradients.loginGradient,
                    textStyle: AppTextStyles.textLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  ///********  METHODS  *********
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      _logar();
    }
  }
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

  void _logar() async {
    _isLoading = await LoginApi(context).login(_email, _senha, _isManterConectado);
  }

  Future<void> _loadConectado() async {
      _isManterConectado = await Utils.recuperarManterConectado();
    setState(() {
      _isManterConectado;
    });
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
