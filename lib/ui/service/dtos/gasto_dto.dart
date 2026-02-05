import 'package:controle_de_gastos_app/ui/core/enums/status_pagamento_enum.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';

import '../../data/model/agenda_de_pagamento.dart';
import 'agenda_de_pagamento_dto.dart';

class GastoDTO {
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
  AgendaDePagamentoDTO? agendaDePagamento;
  String? photoName;
  String? imagemBase64;

  GastoDTO(
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
        this.agendaDePagamento,
        this.photoName,
        this.imagemBase64,
        this.pago});

  GastoDTO.fromJson(Map<String, dynamic> json) {
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
    agendaDePagamento = json['agendaDePagamento'] != null ? AgendaDePagamentoDTO.fromJson(json['agendaDePagamento']) : null;
    photoName = json['photoName'];
    imagemBase64 = json['imagemBase64'];
    pago = json['pago'];

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
    if (agendaDePagamento != null) {
      data['agendaDePagamento'] = agendaDePagamento!.toJson();
    }
    data['photoName'] = photoName;
    data['imagemBase64'] = imagemBase64;
    data['pago'] = pago;

    return data;
  }
}
