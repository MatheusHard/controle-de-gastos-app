import 'package:flutter/material.dart';

class CustomAnoDropdown extends StatelessWidget {
  const CustomAnoDropdown({
    super.key,
    required this.anoAtual,
    required this.anoSelecionado,
    required this.onChanged,
  });

  final int anoAtual;
  final int anoSelecionado;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Ano'),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: anoSelecionado,
            items: List.generate(10, (index) {
              final ano = anoAtual - index;
              return DropdownMenuItem(value: ano, child: Text('$ano'));
            }),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
