import 'package:controle_de_gastos_app/ui/core/constants/enums/status_pagamento_enum.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';

class BottomSheetFiltroRelatorio extends StatefulWidget {
  const BottomSheetFiltroRelatorio({
    super.key,
    required this.onConfirm,
  });

  final Function(
      DateTime? dataInicial,
      DateTime? dataFinal,
      StatusPagamentoEnum? status,
      ) onConfirm;

  @override
  State<BottomSheetFiltroRelatorio> createState() =>
      _BottomSheetFiltroRelatorioState();

  static Future<void> show(
      BuildContext context, {
        required Function(
            DateTime? dataInicial,
            DateTime? dataFinal,
            StatusPagamentoEnum? status,
            ) onConfirm,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => BottomSheetFiltroRelatorio(
        onConfirm: onConfirm,
      ),
    );
  }
}

class _BottomSheetFiltroRelatorioState
    extends State<BottomSheetFiltroRelatorio> {
  DateTime? dataInicial;
  DateTime? dataFinal;
  StatusPagamentoEnum? status;

  Future<void> _selecionarDataInicial() async {
    final data = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: dataInicial ?? DateTime.now(),
    );

    if (data != null) {
      setState(() => dataInicial = data);
    }
  }

  Future<void> _selecionarDataFinal() async {
    final data = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: dataFinal ?? DateTime.now(),
    );

    if (data != null) {
      setState(() => dataFinal = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Filtros",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                dataInicial == null
                    ? "Data Inicial"
                    : Utils.formatarDateTime(dataInicial!),
              ),
              onTap: _selecionarDataInicial,
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                dataFinal == null
                    ? "Data Final"
                    : Utils.formatarDateTime(dataFinal!),
              ),
              onTap: _selecionarDataFinal,
            ),

            DropdownButtonFormField<StatusPagamentoEnum>(
              value: status,
              decoration: const InputDecoration(
                labelText: "Status Pagamento",
              ),
              items: StatusPagamentoEnum.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Gerar Relatório"),
                onPressed: () {
                  widget.onConfirm(
                    dataInicial,
                    dataFinal,
                    status,
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}