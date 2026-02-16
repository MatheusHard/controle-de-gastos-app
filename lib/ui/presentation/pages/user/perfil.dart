import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/core/theme/styles/app_text_styles.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_back.dart';
import 'package:controle_de_gastos_app/ui/presentation/widgets/appbar/app_bar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/imgs/img_url.dart';
import '../../../core/theme/gradients/app_gradients.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  User? user;

  // índice do gradiente selecionado
  int? selectedIndex;

  @override
  void initState() {
    _loadingUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gradients = AppGradients.getAllGradients().entries.toList();

    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Utils.sizedBox(altura: 20.0, largura: 0),
            Text("Dados de Usuario",
              style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
            Utils.sizedBox(altura: 20.0, largura: 0),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                ImgUrl.user, // TODO imagem vir da api cadastro usuario
                height: MediaQuery.of(context).size.width / 5,
                // width: MediaQuery.of(context).size.width / 10,
              ),
            ),
            Utils.sizedBox(altura: 20.0, largura: 0),
            Text("Usuario: ${user?.username ?? ""}", style: AppTextStyles.textoSentimentoNegritoWhite(27, context)),            Utils.sizedBox(altura: 20.0, largura: 0),
            Text("E-mail: ${user?.email ?? ""}" , style: AppTextStyles.textoSentimentoNegritoWhite( 27, context)),
            Utils.sizedBox(altura: 10.0, largura: 0),            ExpansionTile(
              title: Text(
                "Gradientes disponíveis",
                style: AppTextStyles.textoSentimentoNegritoWhite(22, context),
              ),
              children: [
                SizedBox(
                  height: 300,
                  child: GridView.builder(
                    itemCount: gradients.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final entry = gradients[index];
                      final isSelected = selectedIndex == index;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            context.read<ThemeProvider>().setGradient(entry.value); //Setar o gradiente
                          });
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
                          alignment: Alignment.center,
                          child: Text(""),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }
}
