import 'package:controle_de_gastos_app/ui/features/pages/fatura_cadastro_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/fatura_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/home_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/login_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {

  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String fatura = '/fatura_page';
  static const String fatura_cadastro = '/fatura_cadastro_page';


  static Map<String, WidgetBuilder> routes = {
    home: (BuildContext context) => HomePage(),
    login: (BuildContext context) => LoginPage(),
    fatura: (BuildContext context) => FaturaPage(),
    fatura_cadastro: (BuildContext context) => FaturaCadastroPage(),
  };
}
