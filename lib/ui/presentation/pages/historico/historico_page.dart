import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:flutter/material.dart';

import '../../../data/dtos/agenda_de_pagamento_dto.dart';
import '../../../data/dtos/gasto_dto.dart';
import '../../../data/model/gasto.dart';
import '../../../data/service/api/gasto_api.dart';

class Gasto2 {
  final String descricao;
  final double valor;
  final DateTime data;

  Gasto2({
    required this.descricao,
    required this.valor,
    required this.data,
  });
}

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {

  User? user;
  List<Gasto> listaGastos = [];
  bool isLoading = true;
  double total = 0;

  Future<void> baixarExcel() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download do Excel iniciado'),
      ),
    );

    // chamar geração excel aqui
  }

  Future<void> baixarPdf() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download do PDF iniciado'),
      ),
    );

    // chamar geração pdf aqui
  }

  @override
  void initState() {
    _loadingUser();
    _getGastos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Gastos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: baixarExcel,
                    icon: const Icon(Icons.table_view),
                    label: const Text("Baixar Excel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: baixarPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Baixar PDF"),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total de Gastos",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(Utils.formatMoeda(total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: listaGastos.length,
              itemBuilder: (context, index) {
                final gasto = listaGastos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar( //TODO
                      child: Text(
                        'A',
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
              },
            ),
          ),
        ],
      ),
    );
  }
  //Carregar User
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  //Get Gastos
  Future<void> _getGastos() async {
    GastoDTO filters = GastoDTO();
    filters.deletado = false;
    final gastos = await GastoApi().getListByFilter(filters);
    setState(() {
      listaGastos = gastos;
      total = Utils.sumTotalGastos(gastos);
      isLoading = false;
    });
  }

}