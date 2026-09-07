import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import '../dtos/agenda_de_pagamento_dto.dart';
import '../dtos/request/created/agenda_de_pagameto_created_request_dto.dart';
import '../dtos/request/created/gasto_created_request_dto.dart';
import '../dtos/request/get/agenda_de_pagamento_request_dto.dart';
import '../dtos/request/updated/gasto_updated_request_dto.dart';
import '../model/agenda_de_pagamento.dart';
import '../model/gasto.dart';
import '../service/api/agenda_de_pagamento_api.dart';
import '../service/api/gasto_api.dart';

class AgendaDePagamentoRepository {

  final AgendaDePagamentoApi api;

  AgendaDePagamentoRepository({
    required this.api,
  });

  Future<AgendaDePagamento?> addAgendaDePagamento(AgendaDePagamentoCreatedRequestDTO agenda) {
    return api.addAgendaDePagamento(agenda);
  }

  Future<List<AgendaDePagamento>> getList(){
    return api.getList();
  }

  Future<List<AgendaDePagamento>> getListByFilter(AgendaDePagamentoDTO filtros){
    return api.getListByFilter(filtros);
  }

  Future<AgendaDePagamento?> getOneByFilter(AgendaDePagamentoRequestDTO filtros){
    return api.getOneByFilter(filtros);
  }
}