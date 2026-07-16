import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/agenda_de_pagamento.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/dio/configs.dart';
import '../../dtos/agenda_de_pagamento_dto.dart';
import '../../dtos/request/get/agenda_de_pagamento_request_dto.dart';


class AgendaDePagamentoApi  {

  BuildContext? _context;
  final URL = "/agendasdepagamento";
  final FILTRAR = '/filtrar';
  final FIND_ONE = '/findOne';

  AgendaDePagamentoApi();

  //Add
  Future<AgendaDePagamento?> addAgendaDePagamento(AgendaDePagamentoDTO agenda) async {
    final configs = await Configs.create();
    var response = await configs.dio.post(URL,
      data: agenda.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.data != null ? AgendaDePagamento.fromJson(response.data) : null;
  }

  //Find All
    Future<List<AgendaDePagamento>> getList() async {
    final configs = await Configs.create();
    var response = await configs.dio.get(URL,
      options: Options(
      headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => AgendaDePagamento.fromJson(json)).toList();
    }
    return [];
  }

  //Find All By Filters
  Future<List<AgendaDePagamento>> getListByFilter(AgendaDePagamentoDTO filtros) async {
    final configs = await Configs.create();
    var response = await configs.dio.post(
      URL+FILTRAR,
      data: 	 filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),);
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => AgendaDePagamento.fromJson(json)).toList();
    }
    return [];
  }
  //Find Object
  Future<AgendaDePagamento?> getOneByFilter(AgendaDePagamentoRequestDTO filtros) async {
    final configs = await Configs.create();
    var response = await configs.dio.get(
      URL+FIND_ONE,
      queryParameters: 	filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),);
    if (response.statusCode == 200 && response.data != null && response.data != "") {
      return AgendaDePagamento.fromJson(response.data);
    }
    return null;
  }
}


