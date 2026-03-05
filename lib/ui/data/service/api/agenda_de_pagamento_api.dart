import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/dio/configs.dart';
import '../../dtos/agenda_de_pagamento_dto.dart';


class AgendaDePagamentoApi  {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = "/agendasdepagamento";
  final FILTRAR = '/filtrar';
  final FIND_ONE = '/findOne';

  AgendaDePagamentoApi(BuildContext context) {
    _context = context;
  }
  //Add
  Future<AgendaDePagamento?> addAgendaDePagamento(AgendaDePagamentoDTO agenda) async {
    var response = await _customDio.dio.post(URL,
      data: agenda.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.data != null ? AgendaDePagamento.fromJson(response.data) : null;
  }
  //Find All
  Future<List<AgendaDePagamento>> getList() async {
    var response = await _customDio.dio.get(URL,
      options: Options(
      headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => AgendaDePagamento.fromJson(json)).toList();
    }
    return [];
  }
  //Find All By Filters
  Future<List<AgendaDePagamento>> getListByFilter(AgendaDePagamentoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL+FILTRAR,
      data: 	filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => AgendaDePagamento.fromJson(json)).toList();
    }
    return [];
  }
  //Find Object
  Future<AgendaDePagamento?> getOneByFilter(AgendaDePagamentoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL+FIND_ONE,
      data: 	filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),);
    if (response.statusCode == 200 && response.data != null && response.data != "") {
      return AgendaDePagamento.fromJson(response.data);
    }
    return null;
  }
}


