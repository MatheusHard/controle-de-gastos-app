
import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/cards/card_gasto.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/utils.dart';
import '../../data/model/user.dart';
import '../../service/api/agenda_de_pagamento_api.dart';
import '../../service/dtos/agenda_de_pagamento_dto.dart';
import '../../service/dtos/user_dto.dart';
import 'components/appbar/app_bar_usuario.dart';

class FaturaPage extends StatefulWidget {
  const FaturaPage({super.key});

  @override
  State<FaturaPage> createState() => _FaturaPageState();
}

class _FaturaPageState extends State<FaturaPage> {

  User? user;
  List<AgendaDePagamento> listaFaturas = [];
  List<Gasto> listaGastos = [];
  AgendaDePagamento  agendaMes = AgendaDePagamento();
  bool isLoading = true;

  @override
  void initState () {
    super.initState();
    _loadingUser();
    _loadingFaturas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUser(user, "", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 50,
            ))
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: listaGastos.length,
          itemBuilder: (context, index) {
            final gasto = listaGastos[index];

            return Dismissible(
              key: ValueKey(gasto.id), // precisa de chave única
              direction: DismissDirection.endToStart, // swipe da direita p/ esquerda
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                setState(() {
                  listaGastos.removeAt(index);
                });
                // aqui você pode chamar a API para remover no backend também
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${gasto.descricao} removida")),
                );
              },
              child: CardGastoItem(
                icon: Icons.receipt_long,
                label: gasto.descricao ?? "Sem nome",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.fatura_cadastro, arguments: gasto);
                },
                statusPagamento: gasto.statusPagamento ?? StatusPagamentoEnum.NAO_PAGO,
              ),
            );
          },
        )
      ),
      // TODO
      floatingActionButton: FloatingActionButton.small(onPressed: (){
        Navigator.pushNamed(context, AppRoutes.fatura_cadastro, arguments: null);
      }),
    );
  }
  ///METHODS
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  Future<void> _loadingFaturas() async {

    AgendaDePagamentoDTO filters = AgendaDePagamentoDTO();
    filters.dataInicial =   Utils.dateFirstOrLast(true);
    filters.dataFinal = Utils.dateFirstOrLast(false);

    final u = UserDTO();
    u.id = user?.id;
    filters.user = u;

    final list = await AgendaDePagamentoApi(context).getListByFilter(filters);
    setState(() {
      listaFaturas = list;
      listaGastos =  (list.isNotEmpty && list[0].gastos!.isNotEmpty ? list[0].gastos : [])!;
      agendaMes.id = (list.isNotEmpty ? list[0].id : 0)!;
      isLoading = false;
    });
    _atualizarStatusPagamento();
  }
  void _atualizarStatusPagamento(){
    listaGastos.forEach((gasto) {
      gasto.statusPagamento = Utils.isVencido(gasto.vencimento) && gasto.pago! == false ? StatusPagamentoEnum.VENCIDO : gasto.statusPagamento;
      gasto.agendaDePagamento = agendaMes;
    });
    setState(() {
      listaGastos;
    });
  }
}
