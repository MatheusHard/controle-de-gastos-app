import 'package:controle_de_gastos_app/ui/core/enums/app_platform.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:flutter/material.dart';

class LogoImg extends StatelessWidget {
  final double width;
  final double tamanho;
  final String url;

  const LogoImg({
    Key? key,
    required this.width,
    required this.tamanho,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String imgFinal = Utils.imgUrlFinish(url);
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: const EdgeInsets.all(50),
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
    );
  }
}