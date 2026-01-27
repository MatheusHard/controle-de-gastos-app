import 'package:controle_de_gastos_app/ui/core/routes/app_routes.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/appbar/app_bar_usuario.dart';
import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';
import '../../data/model/user.dart';
import 'components/cards/card_principal_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  User? user;

  @override
  void initState () {
    super.initState();
    _loadingUser();
  }

  @override
  Widget build(BuildContext context) {

    String mes_ano = Utils.mouthYearFormated();

    return Scaffold(
      appBar: AppBarUser(user, "", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            CardPrincipalItem(icon: Icons.receipt_long, label: "Faturas $mes_ano", onTap: () {
              Navigator.pushNamed(context, AppRoutes.fatura);
            }),
            CardPrincipalItem(icon: Icons.history_outlined, label: "Histórico", onTap: () {}),
            CardPrincipalItem(icon: Icons.dashboard, label: "DashBoarding", onTap: () {}),
            CardPrincipalItem(icon: Icons.credit_card, label: "Cartões", onTap: () {}),
            CardPrincipalItem(icon: Icons.attach_money, label: "Empréstimos", onTap: () {}),
            CardPrincipalItem(icon: Icons.trending_up, label: "Faça render", onTap: () {}),
          ],
        ),
      ),

    );
  }

  ///METHODS
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

}
