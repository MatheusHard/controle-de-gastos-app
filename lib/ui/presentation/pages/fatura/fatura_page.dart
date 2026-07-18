
import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/updated/gasto_updated_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/constants/enums/status_pagamento_enum.dart';
import '../../../core/constants/routes/app_routes.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dtos/agenda_de_pagamento_dto.dart';
import '../../../data/dtos/gasto_dto.dart';
import '../../../data/dtos/request/created/agenda_de_pagameto_created_request_dto.dart';
import '../../../data/dtos/request/get/agenda_de_pagamento_request_dto.dart';
import '../../../data/dtos/user_dto.dart';
import '../../../data/model/user.dart';
import '../../../data/service/api/agenda_de_pagamento_api.dart';
import '../../../data/service/api/gasto_api.dart';
import '../../widgets/appbar/app_bar_usuario.dart';
import '../../widgets/buttons/floating_action_button/custom_floating_action_button.dart';
import '../../widgets/cards/card_gasto.dart';

class FaturaPage extends StatefulWidget {
  const FaturaPage({super.key});

  @override
  State<FaturaPage> createState() => _FaturaPageState();
}

class _FaturaPageState extends State<FaturaPage> {

  User? user;
  AgendaDePagamento faturaAtual = AgendaDePagamento();
  List<Gasto> listaGastos = [];
  bool isLoading = true;

  @override
  void initState () {
    super.initState();
    _init();
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
                onTap: () async {
                  final resultado = await Navigator.pushNamed(
                    context,
                    AppRoutes.edit_fatura,
                    arguments: {
                      'gasto': gasto,
                    },
                  );
                  if (resultado == true) {
                    await _getGastos();
                    _atualizarStatusPagamento();
                    setState(() {});
                  }
                },
                statusPagamento: gasto.statusPagamento ?? StatusPagamentoEnum.NAO_PAGO,
              ),
            );
          },
        )
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () async {
          Gasto gasto = Gasto();
          gasto.agendaDePagamento = faturaAtual;
          final resultado = await Navigator.pushNamed(
            context,
            AppRoutes.add_fatura,
            arguments: {
              'gasto': gasto,
            },          );
          if (resultado == true) {
            // recarrega lista do backend
            await _getGastos();
            _atualizarStatusPagamento();
            setState(() {});
          }

        },
      ),
    );
  }

  ///******** METHODS ********

  Future<void> _init() async {
    await _loadingUser();
    await _loadingFaturaAtual();
  }

  //Carregar User
  Future<void> _loadingUser() async {
    user = await Utils.recuperarUser();
  }

  //Carregar fatura
  Future<void> _loadingFaturaAtual() async {
    AgendaDePagamentoRequestDTO filters = AgendaDePagamentoRequestDTO();
    filters.dataInicial = Utils.dateFirstOrLast(true);
    filters.dataFinal = Utils.dateFirstOrLast(false);
    filters.deletado = false;
    filters.userId = user?.id;

    await _getOrAddFatura(filters);
    _atualizarStatusPagamento();
      setState(() {
        faturaAtual;
        listaGastos;
        isLoading = false;
      });
  }
  //Get or Add Fatura
  Future<void> _getOrAddFatura(AgendaDePagamentoRequestDTO filters) async {
    //final fatura =   await AgendaDePagamentoApi().getOneByFilter(filters);
    //if(fatura == null){
      faturaAtual = (await AgendaDePagamentoApi().addAgendaDePagamento(await _generateFatura()))!;
   // }else{
     // faturaAtual = fatura;
   // }
    await _getGastos();
  }
  //Gerar Fatura
  Future<AgendaDePagamentoCreatedRequestDTO> _generateFatura() async {

    String dataAtual = DateTime.now().toIso8601String();
    AgendaDePagamentoCreatedRequestDTO a = AgendaDePagamentoCreatedRequestDTO();
    a.deletado = false;
    a.updatedAt = dataAtual;
    a.createdAt = dataAtual;
    UserDTO u = UserDTO();
    a.userId = user?.id;
    return a;
  }

  //Atualizar Status de pagamento
  void _atualizarStatusPagamento(){
    for (var gasto in listaGastos) {
      gasto.statusPagamento = Utils.isVencido(gasto.vencimento) && gasto.pago! == false ? StatusPagamentoEnum.VENCIDO : gasto.statusPagamento;
      gasto.agendaDePagamento = faturaAtual;
    }
    setState(() {
      listaGastos;
    });
  }
  //Deletar Gasto
  Future<bool> _deletarGasto(GastoUpdatedRequestDto g,  BuildContext context) async {
      return await GastoApi().updateGasto(g, user?.id ?? 0);
  }
  //Gerar obj delete Gasto
  Future<GastoUpdatedRequestDto> _generateDelGasto(Gasto gasto) async {
    GastoUpdatedRequestDto g = GastoUpdatedRequestDto();
    g.id =  gasto.id;
    g.descricao = gasto.descricao;
    g.valor = gasto.valor;
    g.vencimento = gasto.vencimento;
    g.createdAt = gasto.createdAt;
    g.updatedAt = DateTime.now().toIso8601String();
    g.imagemBase64 = null;
    g.photoName =  null;
    g.userId = user?.id;
    g.agendaDePagamentoId =  gasto.agendaDePagamento?.id;
    g.deletado = true;
    g.statusPagamento = gasto.statusPagamento;
    g.pago = gasto.pago;
    return g;
  }
  //Get Gastos
  Future<void> _getGastos() async {
    GastoRequestDTO filters = GastoRequestDTO();
    filters.deletado = false;
    filters.agendaDePagamentoId = faturaAtual.id;
    listaGastos = await GastoApi().getListByFilter(filters);
  }
}
