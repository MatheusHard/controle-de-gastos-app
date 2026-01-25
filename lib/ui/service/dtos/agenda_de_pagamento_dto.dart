import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/user_dto.dart';

class AgendaDePagamentoDTO {
  int? id;
  String? createdAt;
  String? updatedAt;
  UserDTO? user;
  bool? deletado;
  String? dataInicial;
  String? dataFinal;

  AgendaDePagamentoDTO(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.deletado,
        this.dataInicial,
        this.dataFinal});

  AgendaDePagamentoDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? UserDTO.fromJson(json['user']) : null;
    deletado = json['deletado'];
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
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    return data;
  }
}


