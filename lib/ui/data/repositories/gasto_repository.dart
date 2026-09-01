import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import '../dtos/request/created/gasto_created_request_dto.dart';
import '../dtos/request/updated/gasto_updated_request_dto.dart';
import '../model/gasto.dart';
import '../service/api/gasto_api.dart';

class GastoRepository {

  final GastoApi api;

  GastoRepository({
    required this.api,
  });

  Future<bool> addGasto(GastoCreatedRequestDTO gasto) {
    return api.addGasto(gasto);
  }

  Future<bool> updateGasto(GastoUpdatedRequestDto gasto, int userId) {
    return api.updateGasto(gasto, userId);
  }

  Future<List<Gasto>> getList(){
    return api.getList();
  }

  Future<List<Gasto>> getListByFilter(GastoRequestDTO filtros){
    return api.getListByFilter(filtros);
  }
}