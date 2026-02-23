import 'package:controle_de_gastos_app/ui/presentation/pages/dashboard/dashboard_page.dart';
import 'package:controle_de_gastos_app/ui/presentation/pages/user/perfil.dart';
import 'package:flutter/material.dart';
import '../../../data/model/gasto.dart';
import '../../../presentation/pages/fatura/fatura_cadastro_page.dart';
import '../../../presentation/pages/fatura/fatura_page.dart';
import '../../../presentation/pages/home/home_page.dart';
import '../../../presentation/pages/login/login_page.dart';

class AppRoutes {
  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String fatura = '/fatura_page';
  static const String fatura_cadastro = '/fatura_cadastro_page';
  static const String perfil = '/perfil_page';
  static const String dashboard = '/dashboard_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case fatura:
        return MaterialPageRoute(builder: (_) => FaturaPage());
      case fatura_cadastro:
        final args = settings.arguments as Map<String, dynamic>;
        final gasto = args['gasto'] as Gasto?;
        final isEdit = args['isEdit'] as bool;
        return MaterialPageRoute(builder: (_) => FaturaCadastroPage(gasto: gasto, isEdit: isEdit),);
      case perfil:
        return MaterialPageRoute(builder: (_) => PerfilPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashBoardPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
