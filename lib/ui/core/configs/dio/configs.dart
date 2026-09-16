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
      // URL
      config._dio.options.baseUrl = isProd ? URL_PROD : URL_HOMOLOG;
      // Timeout para estabelecer conexão
      config._dio.options.connectTimeout = const Duration(seconds: 10);
      // Timeout para enviar os dados
      config._dio.options.sendTimeout = const Duration(seconds: 30);
      // Timeout aguardando a resposta do servidor
      config._dio.options.receiveTimeout = const Duration(seconds: 30);

    return config;
  }
}