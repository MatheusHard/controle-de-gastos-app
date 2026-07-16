
class AgendaDePagamentoRequestDTO {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? userId;
  bool? deletado;
  String? dataInicial;
  String? dataFinal;

  AgendaDePagamentoRequestDTO(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.deletado,
        this.dataInicial,
        this.dataFinal});

  AgendaDePagamentoRequestDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    deletado = json['deletado'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['deletado'] = deletado;
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    return data;
  }
}


