import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/gradients/app_gradients.dart';
import '../../../../core/theme/provider/theme_provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.tooltip = 'Adicionar Cliente',
    this.icon = Icons.add,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      tooltip: tooltip,
      backgroundColor: Colors.transparent, // transparente para mostrar o gradiente
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider
        ),
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}