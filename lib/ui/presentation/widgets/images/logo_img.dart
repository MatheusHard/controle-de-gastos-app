import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoImg extends StatelessWidget {
  final double width;
  final double tamanho;
  final String url;
  final Function(bool isHomologacao)? onChangeAmbiente;

  const LogoImg({
    Key? key,
    required this.width,
    required this.tamanho,
    required this.url,
    this.onChangeAmbiente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgFinal = Utils.imgUrlFinish(url);

    return Hero(
      tag: 'hero',
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: GestureDetector(
          onLongPress: () async {
            final bool? entrarHomologacao = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Modo Homologação'),
                  content: const Text(
                    'Deseja entrar no modo Homologação?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Não'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Sim'),
                    ),
                  ],
                );
              },
            );

            if (entrarHomologacao == true) {
              // homologação
              await Utils.saveUrlIsProd(false);
              // ATUALIZA A TELA
              onChangeAmbiente?.call(true);
            } else if (entrarHomologacao == false) {
              // produção
              await Utils.saveUrlIsProd(true);
              // ATUALIZA A TELA
              onChangeAmbiente?.call(false);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width / 8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(4, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                imgFinal,
                fit: BoxFit.cover,
                width: width / tamanho,
              ),
            ),
          ),
        ),
      ),
    );
  }
}