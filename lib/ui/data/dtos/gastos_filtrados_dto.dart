import '../model/gasto.dart';

class GastosFiltradosDTO {
  final List<Gasto> content;
  final int? totalPages;
  final int totalElements;
  final double totalValor;

  GastosFiltradosDTO({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.totalValor,
  });

  factory GastosFiltradosDTO.fromJson(Map<String, dynamic> json) {
    final content = (json['content'] as List<dynamic>)
        .map((item) => Gasto.fromJson(item))
        .toList();

    return GastosFiltradosDTO(
      content: content,
      totalPages: json['totalPages'] as int?,
      totalElements: json['totalElements'] as int,
      totalValor: (json['totalValor'] as num).toDouble(),
    );
  }

  factory GastosFiltradosDTO.fromList(List<Gasto> content) {
    return GastosFiltradosDTO(
      content: content,
      totalPages: null,
      totalElements: content.length,
      totalValor: content.fold<double>(
        0,
        (total, gasto) => total + (gasto.valor ?? 0),
      ),
    );
  }
}
