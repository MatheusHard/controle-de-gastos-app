import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10, height: 8),
                Icon(Icons.document_scanner_outlined),
                const SizedBox(width: 12, height: 8),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            GestureDetector(
              onTap: () => onToggle(!value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: value ? activeColor : inactiveColor,
                ),
                child: Align(
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(
          thickness: 1,
          color: Colors.black12, // cor suave como nos inputs
        ),
      ],
    );
  }
}