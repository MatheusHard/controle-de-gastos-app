import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/provider/theme_provider.dart';

class AppBarHeaderPhoto extends StatelessWidget {
  final String titulo;
  final VoidCallback onClose;

  const AppBarHeaderPhoto({
    super.key,
    required this.titulo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: context.watch<ThemeProvider>().currentGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),

          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}