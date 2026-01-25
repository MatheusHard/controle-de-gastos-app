import 'package:controle_de_gastos_app/ui/data/model/user.dart';

import 'gasto.dart';

class AgendaDePagamento {
  int? id;
  String? createdAt;
  String? updatedAt;
  User? user;
  bool? deletado;
  List<Gasto>? gastos;
  String? dataInicial;
  String? dataFinal;

  AgendaDePagamento(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.deletado,
        this.gastos,
        this.dataInicial,
        this.dataFinal});

  AgendaDePagamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    deletado = json['deletado'];
    if (json['gastos'] != null) {
      gastos = <Gasto>[];
      json['gastos'].forEach((v) {
        gastos!.add(Gasto.fromJson(v));
      });
    }
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['deletado'] = deletado;
    if (gastos != null) {
      data['gastos'] = gastos!.map((v) => v.toJson()).toList();
    }
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    return data;
  }
}


