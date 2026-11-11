class DashboardRequestDto {
  int? userId;
  bool? deletado;
  int? ano;

  DashboardRequestDto({this.userId, this.deletado, this.ano});

  DashboardRequestDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    deletado = json['deletado'];
    ano = json['ano'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deletado': deletado,
      'ano': ano
    };
  }
}
