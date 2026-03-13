class GastosMensais {
  int? mes;
  double? total;
  String? mesAbreviado;

  GastosMensais({this.mes, this.total, this.mesAbreviado});

  GastosMensais.fromJson(Map<String, dynamic> json) {
    mes = json['mes'];
    total = json['total'];
    mesAbreviado = json['mesAbreviado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mes'] = mes;
    data['total'] = total;
    data['mesAbreviado'] = mesAbreviado;
    return data;
  }
}

