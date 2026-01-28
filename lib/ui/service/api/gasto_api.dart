import 'package:controle_de_gastos_app/ui/core/configurations/dio/configs.dart';
import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/agenda_de_pagamento_dto.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/gasto_dto.dart';
import 'package:controle_de_gastos_app/ui/service/dtos/user_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class GastoApi  {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = "/gasto";
  final FILTRAR = '/filtrar';

  GastoApi(BuildContext context) {
    _context = context;
  }

  @override
  Future<bool> addGasto(GastoDTO gasto) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.post(URL,
      data: gasto.toJson(),
      options: Options(headers: await Utils.requestToken()),);

    return true;
  }

  Future<List<Gasto>> getList() async {
    var response = await _customDio.dio.get(URL, options: Options(headers: await Utils.requestToken()),);

    if (response.statusCode == 200) {
      var lista = response.data;
      List<Gasto> gastos = (lista as List).map((json) => Gasto.fromJson(json)).toList();
      return gastos;
    }
    return [];
  }

  Future<List<AgendaDePagamento>> getListByFilter(GastoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL+FILTRAR,
      data: 	filtros.toJson(),
      options: Options( headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      var lista = response.data;
      List<AgendaDePagamento> faturas = (lista as List).map((json) => AgendaDePagamento.fromJson(json)).toList();
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