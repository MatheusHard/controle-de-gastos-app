import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';

class PerfilRepository {

  Future<User?> recuperarUsuario() async {
    return await Utils.recuperarUser();
  }
}