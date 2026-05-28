import 'package:controle_de_gastos_app/ui/presentation/pages/dashboard/dashboard_page.dart';
import 'package:controle_de_gastos_app/ui/presentation/pages/historico/historico_page.dart';
import 'package:controle_de_gastos_app/ui/presentation/pages/user/perfil.dart';
import 'package:flutter/material.dart';
import '../../../data/model/gasto.dart';
import '../../../presentation/pages/fatura/add_fatura_page.dart';
import '../../../presentation/pages/fatura/edit_fatura_page.dart';
import '../../../presentation/pages/fatura/fatura_page.dart';
import '../../../presentation/pages/home/home_page.dart';
import '../../../presentation/pages/login/login_page.dart';

class AppRoutes {
  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String fatura = '/fatura_page';
  static const String add_fatura = '/add_fatura_page';
  static const String edit_fatura = '/edit_fatura_page';
  static const String perfil = '/perfil_page';
  static const String dashboard = '/dashboard_page';
  static const String historico = '/historico_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case fatura:
        return MaterialPageRoute(builder: (_) => FaturaPage());
      case add_fatura:
        final args = settings.arguments as Map<String, dynamic>;
        final gasto = args['gasto'] as Gasto?;
        //final isEdit = args['isEdit'] as bool;
        return MaterialPageRoute(builder: (_) => AddFaturaPage(gasto: gasto),);
      case edit_fatura:
        final args = settings.arguments as Map<String, dynamic>;
        final gasto = args['gasto'] as Gasto?;
        return MaterialPageRoute(builder: (_) => EditFaturaPage(gasto: gasto),);
      case perfil:
        return MaterialPageRoute(builder: (_) => PerfilPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashBoardPage());
      case historico:
        return MaterialPageRoute(builder: (_) => HistoricoPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
