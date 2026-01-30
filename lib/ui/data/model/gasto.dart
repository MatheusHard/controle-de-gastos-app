import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';

class Gasto {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? vencimento;
  String? descricao;
  User? user;
  bool? deletado;
  String? dataInicial;
  String? dataFinal;
  StatusPagamentoEnum? statusPagamento;
  double? valor;
  bool? pago = false;
  AgendaDePagamento? agendaDePagamento;

  Gasto(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.vencimento,
        this.descricao,
        this.user,
        this.deletado,
        this.dataInicial,
        this.dataFinal,
        this.statusPagamento,
        this.valor,
        this.pago,
        this.agendaDePagamento
      });

  Gasto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vencimento = json['vencimento'];
    descricao = json['descricao'];
    user = json['user'];
    deletado = json['deletado'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
    statusPagamento = json['statusPagamento'] != null
        ? StatusPagamentoEnum.fromString(json['statusPagamento'])
        : null;
    valor = json['valor'];
    pago = json['pago'];
    agendaDePagamento = json['agendaDePagamento'] != null ? AgendaDePagamento.fromJson(json['agendaDePagamento']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['vencimento'] =vencimento;
    data['descricao'] = descricao;
    data['user'] = user;
    data['deletado'] = deletado;
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    data['statusPagamento'] = statusPagamento?.toJson();
    data['valor'] = valor;
    data['pago'] = pago;
    if (agendaDePagamento != null) {
      data['agendaDePagamento'] = agendaDePagamento!.toJson();
    }
    return data;
  }
}
