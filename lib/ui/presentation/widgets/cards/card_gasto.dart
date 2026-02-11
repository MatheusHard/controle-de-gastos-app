import 'package:flutter/material.dart';

import '../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../core/theme/styles/app_text_styles.dart';

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

  Map<String, dynamic> _getStatusProperties() {
    switch (statusPagamento) {
      case StatusPagamentoEnum.PAGO:
        return {
          'color': Colors.green.shade600,
          'icon': Icons.check_circle_outline,
        };
      case StatusPagamentoEnum.NAO_PAGO:
        return {
          'color': Colors.orange.shade600,
          'icon': Icons.warning,
        };
      case StatusPagamentoEnum.VENCIDO:
        return {
          'color': Colors.red.shade600,
          'icon': Icons.not_interested_outlined,
        };
      }
  }


  @override
  Widget build(BuildContext context) {
    final statusProps = _getStatusProperties();
    final statusColor = statusProps['color'];
    final iconStatusPg = statusProps['icon'];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.4),
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
            // Imagem no canto inferior esquerdo
            Positioned(
              left: 8,
              bottom: 8,
              child: Icon(
                iconStatusPg,
                size: 22,
                color: statusColor,
              ),
            ),

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
              ),
            ),
          ],
        ),
      ),
    );
  }
}