import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/dio/configs.dart';
import '../../dtos/gasto_dto.dart';
import '../../dtos/request/gasto_request_dto.dart';

class GastoApi {

  final URL = "/gastos";
  final FILTRAR = '/filtrar';
  final FIND_ONE = '/findOne';

  GastoApi() {}

  //Add
  Future<bool> addGasto(GastoDTO gasto) async {
    final configs = await Configs.create();
    var response = await configs.dio.post(URL,
      data: gasto.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
  //Update
  Future<bool> updateGasto(GastoDTO gasto, int userId) async {
    final configs = await Configs.create();
    var response = await configs.dio.put(URL,
      data: gasto.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.statusCode == 200;
  }
  //Get All
  Future<List<Gasto>> getList() async {
    final configs = await Configs.create();
    var response = await configs.dio.get(
      URL,
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Gasto.fromJson(json)).toList();
    }
    return [];
  }
  //Get All By Filters
  Future<List<Gasto>> getListByFilter(GastoRequestDTO filtros) async {
    final configs = await Configs.create();

    var response = await configs.dio.get(
      URL + FILTRAR,
      queryParameters: filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Gasto.fromJson(json)).toList();
    }
    return [];
  }
}