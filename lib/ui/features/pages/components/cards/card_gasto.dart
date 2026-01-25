import 'package:flutter/material.dart';

class CardGastoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool pago; // flag para definir cor

  const CardGastoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.pago,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: pago ? Colors.green : Colors.red, // cor dinâmica
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Ícone no canto superior esquerdo
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                icon,
                size: 32,
                color: Colors.white, // contraste com fundo
              ),
            ),
            // Texto centralizado
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // contraste com fundo
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}