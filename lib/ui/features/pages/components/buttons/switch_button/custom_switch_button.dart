import 'package:flutter/material.dart';
import 'package:switch_button/switch_button.dart';

class CustomSwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggle;
  final Color activeColor;
  final Color inactiveColor;
  final String label;

  const CustomSwitchButton({
    Key? key,
    required this.value,
    required this.onToggle,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.red,
    this.label = "Fatura Paga?",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: Colors.transparent, // fundo limpo
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          SwitchButton(
            value: value,
            onToggle: onToggle,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            backgroundColor: Colors.transparent,
            child: const SizedBox.shrink(), // evita texto colado
          ),
        ],
      ),
    );
  }
}