import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/routes/app_routes.dart';
import '../../../core/utils/utils.dart';
import '../../widgets/appbar/app_bar_usuario.dart';
import '../../widgets/cards/card_principal_item.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..init(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    final mesAno = Utils.mouthYearFormated();

    return Scaffold(
      appBar: AppBarUser(
        viewModel.user,
        "",
        context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            CardPrincipalItem(
              icon: Icons.receipt_long,
              label: "Faturas $mesAno",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.fatura,
                );
              },
            ),

            CardPrincipalItem(
              icon: Icons.history_outlined,
              label: "Histórico",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.historico,
                );
              },
            ),

            CardPrincipalItem(
              icon: Icons.dashboard,
              label: "DashBoarding",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.dashboard,
                );
              },
            ),

            CardPrincipalItem(
              icon: Icons.credit_card,
              label: "Cartões",
              onTap: () {},
            ),

            CardPrincipalItem(
              icon: Icons.attach_money,
              label: "Empréstimos",
              onTap: () {},
            ),

            CardPrincipalItem(
              icon: Icons.trending_up,
              label: "Faça render",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}