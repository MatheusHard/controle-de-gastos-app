import '../../../../core/constants/enums/status_pagamento_enum.dart';

class GastoCreatedRequestDTO {

  String? createdAt;
  String? updatedAt;
  String? vencimento;
  String? descricao;
  int? userId;
  bool? deletado;
  String? dataInicial;
  String? dataFinal;
  StatusPagamentoEnum? statusPagamento;
  double? valor;
  bool? pago = false;
  int? agendaDePagamentoId;
  String? photoName;
  String? imagemBase64;

  GastoCreatedRequestDTO(
      {
        this.createdAt,
        this.updatedAt,
        this.vencimento,
        this.descricao,
        this.userId,
        this.deletado,
        this.dataInicial,
        this.dataFinal,
        this.statusPagamento,
        this.valor,
        this.agendaDePagamentoId,
        this.pago,
        this.photoName,
        this.imagemBase64});

  GastoCreatedRequestDTO.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vencimento = json['vencimento'];
    descricao = json['descricao'];
    userId = json['user'];
    deletado = json['deletado'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
    statusPagamento = json['statusPagamento'] = json['statusPagamento'];
    valor = json['valor'];
    agendaDePagamentoId = json['agendaDePagamento'];
    pago = json['pago'];
    photoName = json['photoName'];
    imagemBase64 = json['imagemBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['vencimento'] =vencimento;
    data['descricao'] = descricao;
    data['userId'] = userId;
    data['deletado'] = deletado;
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    data['statusPagamento'] = statusPagamento?.toJson();
    data['valor'] = valor;
    data['agendaDePagamentoId'] = agendaDePagamentoId;
    data['pago'] = pago;
    data['photoName'] = photoName;
    data['imagemBase64'] = imagemBase64;

    return data;
  }
}