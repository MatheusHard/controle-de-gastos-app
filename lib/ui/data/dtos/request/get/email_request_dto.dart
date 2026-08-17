import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';

class EmailRequestDTO {

  String? descricao;
  String? nomeUsuario;
  String? createdAt;
  String? updatedAt;
  String? remetente;
  String? destinatario;
  String? assunto;
  String? corpo;
  GastoRequestDTO? filters;
  String? file;

  EmailRequestDTO(
      {this.descricao,
        this.nomeUsuario,
        this.createdAt,
        this.updatedAt,
        this.remetente,
        this.destinatario,
        this.assunto,
        this.corpo,
        this.filters,
        this.file});

  EmailRequestDTO.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
    nomeUsuario = json['nomeUsuario'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    remetente = json['remetente'];
    destinatario = json['destinatario'];
    assunto = json['assunto'];
    corpo = json['corpo'];
    filters = json['filters'] != null ? GastoRequestDTO.fromJson(json['filters']) : null;
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descricao'] = descricao;
    data['nomeUsuario'] = nomeUsuario;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['remetente'] = remetente;
    data['destinatario'] = destinatario;
    data['assunto'] = assunto;
    data['corpo'] = corpo;
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    data['file'] = file;
    return data;
  }
}
