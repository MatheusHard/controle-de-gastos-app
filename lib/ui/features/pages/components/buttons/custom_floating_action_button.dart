import 'package:flutter/material.dart';
import 'package:controle_de_gastos_app/ui/core/routes/app_routes.dart';

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
    return FloatingActionButton.small(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: Colors.green, // verde
      tooltip: tooltip,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
