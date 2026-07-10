class DashboardRequestDto {
  int? userId;
  bool? deletado;

  DashboardRequestDto({
    this.userId,
    this.deletado,
  });

  DashboardRequestDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    deletado = json['deletado'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deletado': deletado,
    };
  }
}