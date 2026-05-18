import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:dio/dio.dart';

class Configs {

  final _dio = Dio();
  static final URL_PROD    = "https://api-controle-de-gastos.squareweb.app";
  static final URL_HOMOLOG = "https://homolog-api-controle-de-gastos.squareweb.app";
  Dio get dio => _dio;

  Configs();

  static Future<Configs> create() async {
      final config = Configs();
      final bool isProd = await Utils.getIsProd();
      ///URL
      config._dio.options.baseUrl = isProd ? URL_PROD : URL_HOMOLOG;
      ///Timeout
      config._dio.options.connectTimeout = const Duration(seconds: 5);
      ///Receive
      config._dio.options.receiveTimeout = const Duration(seconds: 3);

    return config;
  }
}