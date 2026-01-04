import 'package:controle_de_gastos_app/ui/feature/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    //final viewModel = Provider.of<LoginViewModel>(context);

    return const Scaffold(
      body: Center(
        child: Text("!!")

      ),
    );
  }
}
