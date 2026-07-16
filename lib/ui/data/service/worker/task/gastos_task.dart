import '../../../../core/utils/utils.dart';
import '../../../dtos/request/get/gasto_request_dto.dart';
import '../../../model/gasto.dart';
import '../../../model/user.dart';
import '../../api/gasto_api.dart';
import '../../notifications/notifications.dart';

class GastosTask {

  GastosTask(){}

  static Future<void> contasVencidasDoDiaTask()async {

    User? user = await Utils.recuperarUser();
    List<Gasto> listaGastos = await _loadingGastos(user);

    int idNot = 10;
    for(Gasto gasto in listaGastos){
      await Notifications.showNotification(
          id: idNot,
          title: "Conta à vencer",
          body:  '''Olá Sr.(a) ${user?.username ?? ''}, sua fatura: ${gasto.descricao}, valor ${Utils.formatMoeda(gasto.valor)} vence em ${Utils.formatarData(gasto.vencimento ?? '', false) }'''
      );
      idNot ++;
    }
  }

  static Future<List<Gasto>> _loadingGastos(User? user) async {
      GastoRequestDTO filters = GastoRequestDTO();
      filters.deletado = false;
      filters.userId = user?.id;
      filters.vencimento = DateTime.now().toIso8601String();

    return await GastoApi().getListByFilter(filters);
  }
}