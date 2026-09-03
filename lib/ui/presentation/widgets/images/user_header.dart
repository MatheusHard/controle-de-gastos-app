import 'package:flutter/material.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';

class UserHeader extends StatelessWidget {
  final String title;
  final String image;
  final double imageSize;
  final int titleFontSize;
  final Color? backgroundColor;

   const UserHeader({
    super.key,
    this.title = 'Dados de Usuário',
    this.image = '',
    this.imageSize = 80,
    this.titleFontSize = 20,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Utils.sizedBox(
              altura: 20.0,
              largura: 0,
            ),

            Text(
              title,
              style: AppTextStyles.textoSentimentoNegritoWhite(
                titleFontSize,
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
                image,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

