import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../../data/model/gasto.dart';

class CardGastoHistorico extends StatelessWidget {
  final Gasto gasto;

  const CardGastoHistorico({
    super.key,
    required this.gasto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            (gasto.descricao?.isNotEmpty ?? false)
                ? gasto.descricao![0].toUpperCase()
                : 'A',
          ),
        ),
        title: Text(gasto.descricao ?? ''),
        subtitle: Text(
          Utils.formatarData(gasto.vencimento, true),
        ),
        trailing: Text(
          Utils.formatMoeda(gasto.valor),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}