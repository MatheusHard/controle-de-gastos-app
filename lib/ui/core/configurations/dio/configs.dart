import 'package:dio/dio.dart';

import '../../utils/utils.dart';

class Configs {

  final _dio = Dio();
  Dio get dio => _dio;

  Configs(){
    _dio.options.baseUrl = "http://192.168.137.1:8080"; //Local
    //_dio.options.baseUrl = "https://melodious-beauty-production.up.railway.app"; //Produção
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }
}