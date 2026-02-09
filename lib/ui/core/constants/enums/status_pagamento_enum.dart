enum StatusPagamentoEnum {
  NAO_PAGO,
  VENCIDO,
  PAGO;

  static StatusPagamentoEnum fromString(String value) {
    return StatusPagamentoEnum.values.firstWhere(
          (e) => e.name == value,
      orElse: () => throw ArgumentError('StatusPagamentoEnum inválido: $value'),
    );
  }

  String toJson() => name;

}
