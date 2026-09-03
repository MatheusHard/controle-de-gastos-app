import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/core/theme/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import '../../../core/constants/imgs/img_url.dart';
import '../../../data/repositories/perfil_repository.dart';
import '../../widgets/body/perfil_body.dart';
import '../../widgets/images/user_header.dart';
import '../../widgets/listtile/listtile_gradients.dart';
import '../../widgets/text/perfil_text.dart';
import 'perfil_view_model.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilViewModel(
        repository: PerfilRepository(),
      )..init(),
      child: const _PerfilView(),
    );
  }
}

class _PerfilView extends StatelessWidget {
  const _PerfilView();

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<PerfilViewModel>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: themeProvider.currentGradient,
      ),

      body:
      PerfilBody(
      isLoading: viewModel.isLoading,
      errorMessage: viewModel.errorMessage,
      onRetry: viewModel.carregarUsuario,
      child: Column(
        children: [

          // Imagem User
          UserHeader(
            title: 'Dados de Usuário',
            image: ImgUrl.user,
            imageSize: 90,
            titleFontSize: 22,
          ),

          Utils.sizedBox(altura: 20.0),

          // Usuario
          PerfilText(
              description: 'Usuario: ${viewModel.user?.username ?? ""}',
              fontSize: 27
          ),

          Utils.sizedBox(altura: 20.0),
          // Email
          PerfilText(
              description: 'E-mail: ${viewModel.user?.email ?? ""}',
              fontSize: 27
          ),

          Utils.sizedBox(altura: 20.0),

          //Gradients disponíveis
          ListTileThemeGradients(
            gradients: viewModel.gradients.map((entry) => entry.value).toList(),
            selectedIndex: viewModel.selectedIndex ?? 0,
            onGradientSelected: (index) {
              final themeProvider = context.read<ThemeProvider>();
              viewModel.selecionarGradiente(
                index,
                themeProvider,
              );
            },
          ),
        ],
      ),
    ),
    );
  }
}