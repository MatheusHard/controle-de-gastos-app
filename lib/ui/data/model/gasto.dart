import 'package:controle_de_gastos_app/ui/data/model/user.dart';

class gasto {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? vencimento;
  String? descricao;
  User? user;
  bool? deletado;
  String? dataInicial;
  String? dataFinal;
  double? valor;

  gasto(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.vencimento,
        this.descricao,
        this.user,
        this.deletado,
        this.dataInicial,
        this.dataFinal,
        this.valor});

  gasto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vencimento = json['vencimento'];
    descricao = json['descricao'];
    user = json['user'];
    deletado = json['deletado'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
    valor = json['valor'];
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
    data['valor'] = valor;
    return data;
  }
}
