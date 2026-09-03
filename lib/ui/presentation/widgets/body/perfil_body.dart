import 'package:flutter/material.dart';
import '../../../core/theme/styles/app_text_styles.dart';

class PerfilBody extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Widget child;

  const PerfilBody({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: AppTextStyles.textoSentimentoNegritoWhite(
                18,
                context,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                'Tentar novamente',
              ),
            ),
          ],
        ),
      );
    }

    return child;
  }
}
