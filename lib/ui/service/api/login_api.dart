import 'package:controle_de_gastos_app/ui/feature/model/login.dart';
import 'package:flutter/material.dart';
import '../../core/configurations/dio/configs.dart';
import '../../core/utils/utils.dart';
import '../../feature/model/user.dart';

class LoginApi {

BuildContext? _context;

LoginApi(BuildContext context){
  _context = context;
}

  @override
  Future<bool> login(String username, String password, bool isChecked) async {

    var customDio = Configs();

    String userBase64 = Utils.base64EncodeString(username);
    String passwordBase64 = Utils.base64EncodeString(password);

    try{
        var response = await customDio.dio.post("/login", data: {
          "username": userBase64,
          "password": passwordBase64
        });

        if(response.statusCode == 200){
          Login login = Login.fromJson(response.data);

          ///Salvar Sessão
            if(login.token != null){
              await Utils.salvarToken(login.token ?? "");
              if(isChecked){
                login.user?.username = username;
                login.user?.password = password;
                await Utils.salvarUser(login.user as User);
                await Utils.salvarManterConectado(isChecked);
              }else{
                await Utils.removerUser();
              }

            /*Navigator.push(
                _context!
                //MaterialPageRoute(builder: (context) => HomePage(ScreenArgumentsUser(login)))
            );*/
            return true;
          }
        }
      }catch(error){
        Utils.showDefaultSnackbar(_context!, '''Verifique suas credenciais!!!''');
        return false;
      }
    return true;
  }
}