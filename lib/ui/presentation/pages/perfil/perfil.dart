import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/core/theme/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import '../../../core/constants/imgs/img_url.dart';
import '../../../data/repositories/perfil_repository.dart';
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

      body: _buildBody(
        context,
        viewModel,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      PerfilViewModel viewModel,
      ) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.errorMessage!,
              style: AppTextStyles.textoSentimentoNegritoWhite(
                18,
                context,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: viewModel.carregarUsuario,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildHeader(
            context,
          ),

          Utils.sizedBox(
            altura: 20.0,
            largura: 0,
          ),

          _buildUserName(
            context,
            viewModel,
          ),

          Utils.sizedBox(
            altura: 20.0,
            largura: 0,
          ),

          _buildEmail(
            context,
            viewModel,
          ),

          Utils.sizedBox(
            altura: 10.0,
            largura: 0,
          ),

          _buildGradients(
            context,
            viewModel,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Utils.sizedBox(
            altura: 20.0,
            largura: 0,
          ),

          Text(
            'Dados de Usuario',
            style: AppTextStyles.textoSentimentoNegritoWhite(
              20,
              context,
            ),
          ),

          Utils.sizedBox(
            altura: 20.0,
            largura: 0,
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              ImgUrl.user,
              height: MediaQuery.of(context).size.width / 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(
      BuildContext context,
      PerfilViewModel viewModel,
      ) {
    return Text(
      'Usuario: ${viewModel.user?.username ?? ""}',
      style: AppTextStyles.textoSentimentoNegritoWhite(
        27,
        context,
      ),
    );
  }

  Widget _buildEmail(
      BuildContext context,
      PerfilViewModel viewModel,
      ) {
    return Text(
      'E-mail: ${viewModel.user?.email ?? ""}',
      style: AppTextStyles.textoSentimentoNegritoWhite(
        27,
        context,
      ),
    );
  }

  Widget _buildGradients(
      BuildContext context,
      PerfilViewModel viewModel,
      ) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: ExpansionTile(
        title: Text(
          'Cores disponíveis',
          style: AppTextStyles.textoSentimentoNegritoWhite(
            27,
            context,
          ),
        ),
        children: [
          SizedBox(
            height: 300,
            child: GridView.builder(
              itemCount: viewModel.gradients.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final entry = viewModel.gradients[index];

                final isSelected =
                    viewModel.selectedIndex == index;

                return InkWell(
                  onTap: () {
                    final themeProvider =
                    context.read<ThemeProvider>();

                    viewModel.selecionarGradiente(
                      index,
                      themeProvider,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: entry.value,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                        color: Colors.green,
                        width: 3,
                      )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}