

import 'package:controle_de_gastos_app/ui/core/configurations/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/agenda_de_pagamento_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class AgendaDePagamentoApi  {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = "/agendasdepagamento";
  final FILTRAR = '/filtrar';

  AgendaDePagamentoApi(BuildContext context) {
    _context = context;
  }

  /*@override
  Future<bool> addCliente(Cliente cliente, int user_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.post(URL,
      data: {
        "name": cliente.name,
        "createdAt": cliente.createdAt,
        "updatedAt": cliente.updatedAt,
        "name": cliente.name,
        "cpf": "",
        "email": cliente.email,
        "telephone": cliente.telephone,
        "deletado": cliente.deletado,
        "user": {
          "id":  user_id
        },
        "photoName": cliente.photoName,
        "imagemBase64": cliente.imagemBase64
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );

    return true;
  }*/

  Future<List<AgendaDePagamento>> getList() async {
    var response = await _customDio.dio.get(URL,
      options: Options(
      headers: await Utils.requestToken()),);

    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Cliente
      List<AgendaDePagamento> agendasdepagamento = (lista as List)
          .map((json) => AgendaDePagamento.fromJson(json))
          .toList();

      return agendasdepagamento;
    }

    return [];
  }

  Future<List<AgendaDePagamento>> getListByFilter(AgendaDePagamentoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL+FILTRAR,
      data: 	filtros.toJson(),
      options: Options(
        headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<AgendaDePagamento> faturas = (lista as List)
          .map((json) => AgendaDePagamento.fromJson(json))
          .toList();

      return faturas;
    }
    return [];

  }
  /*@override
  Future<bool> updateCliente(Cliente cliente, int user_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.put(URL,
      data: {
        "id": cliente.id,
        "name": cliente.name,
        "createdAt": cliente.createdAt,
        "updatedAt": cliente.updatedAt,
        "name": cliente.name,
        "cpf": "",
        "email": cliente.email,
        "telephone": cliente.telephone,
        "deletado": cliente.deletado,
        "user": {
          "id":  user_id
        },
        "photoName": cliente.photoName,
        "imagemBase64": cliente.imagemBase64
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );
    return response.statusCode == 200;
  }
*/

}