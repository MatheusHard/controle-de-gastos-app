import 'package:controle_de_gastos_app/ui/features/pages/fatura_cadastro_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/fatura_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/home_page.dart';
import 'package:controle_de_gastos_app/ui/features/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../data/model/gasto.dart';

class AppRoutes {
  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String fatura = '/fatura_page';
  static const String fatura_cadastro = '/fatura_cadastro_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case fatura:
        return MaterialPageRoute(builder: (_) => FaturaPage());
      case fatura_cadastro:
        final gasto = settings.arguments as Gasto?;
        return MaterialPageRoute(builder: (_) => FaturaCadastroPage(gasto: gasto));
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
