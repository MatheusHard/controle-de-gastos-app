import 'gastos_mensais.dart';

class TotaisMensaisResponse {
  List<GastosMensais>? totaisPorMes;
  double? somaTotal;

  TotaisMensaisResponse({this.totaisPorMes, this.somaTotal});

  TotaisMensaisResponse.fromJson(Map<String, dynamic> json) {
    if (json['totaisPorMes'] != null) {
      totaisPorMes = <GastosMensais>[];
      json['totaisPorMes'].forEach((v) {
        totaisPorMes!.add(GastosMensais.fromJson(v));
      });
    }
    somaTotal = json['somaTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totaisPorMes != null) {
      data['totaisPorMes'] = totaisPorMes!.map((v) => v.toJson()).toList();
    }
    data['somaTotal'] = somaTotal;
    return data;
  }
}