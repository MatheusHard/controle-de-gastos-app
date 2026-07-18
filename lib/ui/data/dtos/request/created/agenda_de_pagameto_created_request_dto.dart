
class AgendaDePagamentoCreatedRequestDTO {
  String? createdAt;
  String? updatedAt;
  int? userId;
  bool? deletado;

  AgendaDePagamentoCreatedRequestDTO(
      {
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.deletado,
      });

  AgendaDePagamentoCreatedRequestDTO.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    deletado = json['deletado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['deletado'] = deletado;
    return data;
  }
}


