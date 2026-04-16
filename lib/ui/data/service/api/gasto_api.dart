import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/gasto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/dio/configs.dart';
import '../../dtos/gasto_dto.dart';

class GastoApi {

  final Configs _customDio = Configs();
  final URL = "/gastos";
  final FILTRAR = '/filtrar';
  final FIND_ONE = '/findOne';

  GastoApi() {}
  //Add
  Future<bool> addGasto(GastoDTO gasto) async {
    var response = await _customDio.dio.post(URL,
      data: gasto.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
  //Update
  Future<bool> updateGasto(GastoDTO gasto, int userId) async {
    var response = await _customDio.dio.put(URL,
      data: gasto.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    return response.statusCode == 200;
  }
  //Get All
  Future<List<Gasto>> getList() async {
    var response = await _customDio.dio.get(
      URL,
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Gasto.fromJson(json)).toList();
    }
    return [];
  }
  //Get All By Filters
  Future<List<Gasto>> getListByFilter(GastoDTO filtros) async {
    var response = await _customDio.dio.post(
      URL + FILTRAR,
      data: filtros.toJson(),
      options: Options(headers: await Utils.requestToken()),
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Gasto.fromJson(json)).toList();
    }
    return [];
  }
}