
import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/features/pages/components/cards/card_gasto.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/gasto_dto.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/utils.dart';
import '../../data/model/user.dart';
import '../../service/api/agenda_de_pagamento_api.dart';
import '../../service/api/gasto_api.dart';
import '../../service/dtos/agenda_de_pagamento_dto.dart';
import '../../service/dtos/user_dto.dart';
import 'components/appbar/app_bar_usuario.dart';
import 'components/buttons/floating_action_button/custom_floating_action_button.dart';

class FaturaPage extends StatefulWidget {
  const FaturaPage({super.key});

  @override
  State<FaturaPage> createState() => _FaturaPageState();
}

class _FaturaPageState extends State<FaturaPage> {

  User? user;
  AgendaDePagamento faturasAtual = AgendaDePagamento();
  List<Gasto> listaGastos = [];
  bool isLoading = true;

  @override
  void initState () {
    super.initState();
    _loadingUser();
    _loadingFaturaAtual();
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
              onDismissed: (direction) async {
                setState(() {
                  listaGastos.removeAt(index);
                });
                // aqui você pode chamar a API para remover no backend também
                await _deletarGasto(await _generateDelGasto(gasto), context);
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
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.fatura_cadastro,
            arguments: null,
          );
        },
      )
    );
  }
  ///METHODS
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  Future<void> _loadingFaturaAtual() async {

    AgendaDePagamentoDTO filters = AgendaDePagamentoDTO();
    filters.dataInicial =   Utils.dateFirstOrLast(true);
    filters.dataFinal = Utils.dateFirstOrLast(false);
    filters.deletado = false;
    final u = UserDTO();
    u.id = user?.id;
    filters.user = u;

    await _getOrAddFatura(filters);

    setState(() {
      faturasAtual;
      listaGastos;
      isLoading = false;
      });
    _atualizarStatusPagamento();
  }

  Future<void> _getOrAddFatura(AgendaDePagamentoDTO filters) async {
    // Pegar fatura do mês atual
    final fatura = await AgendaDePagamentoApi(context).getOneByFilter(filters);
    if(fatura == null){
      faturasAtual = (await AgendaDePagamentoApi(context).addAgendaDePagamento(await _generateFatura()))!;
    }else{
      faturasAtual = fatura;
    }
    await _getGastos();
  }

  Future<AgendaDePagamentoDTO> _generateFatura() async {
    String dataAtual = DateTime.now().toIso8601String();
    AgendaDePagamentoDTO a = AgendaDePagamentoDTO();
    a.id =   null;
    a.deletado = false;
    a.updatedAt = dataAtual;
    a.createdAt = dataAtual;
    UserDTO u = UserDTO();
    u.id = user?.id;
    a.user = u;

    return a;
  }

  void _atualizarStatusPagamento(){
    listaGastos.forEach((gasto) {
      gasto.statusPagamento = Utils.isVencido(gasto.vencimento) && gasto.pago! == false ? StatusPagamentoEnum.VENCIDO : gasto.statusPagamento;
      gasto.agendaDePagamento = faturasAtual;
    });
    setState(() {
      listaGastos;
    });
  }

  ///Delete Gasto
  Future<bool> _deletarGasto(GastoDTO g,  BuildContext context) async {
      return await GastoApi(context).updateGasto(g, user?.id ?? 0);
    }
  Future<GastoDTO> _generateDelGasto(Gasto gasto) async {
    GastoDTO g = GastoDTO();
    g.id =  gasto.id;
    g.descricao = gasto.descricao;
    g.valor = gasto.valor;
    g.vencimento = gasto.vencimento;
    g.createdAt = gasto.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = null;
    g.photoName =  null;
    AgendaDePagamentoDTO agenda = AgendaDePagamentoDTO();
    agenda.id = gasto.agendaDePagamento?.id;
    g.user = user;
    g.agendaDePagamento = agenda;
    g.deletado = true;
    g.statusPagamento = gasto.statusPagamento;
    g.pago = gasto.pago;

    return g;
  }

  Future<void> _getGastos() async {
    GastoDTO filters = GastoDTO();
    filters.agendaDePagamento = AgendaDePagamentoDTO(id: faturasAtual.id);
    listaGastos = await GastoApi(context).getListByFilter(filters);
  }
}
