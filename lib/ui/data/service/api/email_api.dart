import 'package:controle_de_gastos_app/ui/core/configs/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/get/email_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/request/get/gasto_request_dto.dart';
import 'package:controle_de_gastos_app/ui/data/dtos/response/email_response_dto.dart';
import 'package:controle_de_gastos_app/ui/data/model/login.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/routes/app_routes.dart';
import '../../../core/utils/utils.dart';

class EmailApi {

  final URL = "/email";
  final SEND_EMAIL = '/sendEmail';
  BuildContext? _context;

  EmailApi(BuildContext context){
    _context = context;
  }

  Future<bool> sendEmail(EmailRequestDTO dto) async {

    final configs = await Configs.create();
    try{

      var response = await configs.dio.post('''$URL$SEND_EMAIL''',
          data: dto.toJson(),
          options: Options(headers: await Utils.requestToken()),
      );

      EmailReponseDTO emailResponse;
      if(response.statusCode == 200 || response.statusCode == 201) {
        emailResponse = EmailReponseDTO.fromJson(response.data);
        Utils.showDefaultSnackbar(_context!,'''Sucess: ${Utils.textoDinamico(inicio: 0, qtdCaracters: 27, value: emailResponse.message.toString())}''');
      }else {
        emailResponse = EmailReponseDTO.fromJson(response.data);
        Utils.showDefaultSnackbar(_context!,'''Erro: ${Utils.textoDinamico(inicio: 0, qtdCaracters: 27, value: emailResponse.message.toString())}''');
      }
    }catch(error){
      Utils.showDefaultSnackbar(_context!,'''Erro: ${Utils.textoDinamico(inicio: 0, qtdCaracters: 27, value: error.toString())}''');
      return false;
    }
    return true;
  }
}