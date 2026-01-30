import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardGastoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final StatusPagamentoEnum statusPagamento;

  const CardGastoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.statusPagamento,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (statusPagamento) {
      case StatusPagamentoEnum.PAGO:
        return Colors.green.shade600;
      case StatusPagamentoEnum.NAO_PAGO:
        return Colors.orange.shade600;
      case StatusPagamentoEnum.VENCIDO:
      default:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.4), // borda suave
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // Ícone fixo no canto superior esquerdo
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                icon,
                size: 22,
                color: statusColor,
              ),
            ),
            // Texto centralizado
            Center(
              child: Text(
                label,
                style: AppTextStyles.subTitleCardBlack(30, context),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ),
          ],
        ),
      ),
    );
  }
}