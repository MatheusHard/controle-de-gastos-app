import 'package:flutter/material.dart';

import '../../../core/theme/styles/app_text_styles.dart';

class PerfilText extends StatelessWidget {
  final String description;
  final int fontSize;

  const PerfilText({
    super.key,
    required this.description,
    this.fontSize = 27,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: AppTextStyles.textoSentimentoNegritoWhite(
        fontSize,
        context,
      ),
    );
  }
}

