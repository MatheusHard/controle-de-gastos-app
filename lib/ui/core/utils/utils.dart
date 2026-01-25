import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../enums/app_platform.dart';

  class Utils {

  static const String _boolKey = 'isLoggedIn';
  ///Servidor
  static String URL_UPLOAD = "uploads/";
  static String URL_IMG_WEB = "images/";
  static String URL_IMG_ANDROID = "assets/images/";

  ///Local
  //static String URL_WEB_SERVICE = "http://192.168.0.7:5001/api/";
  static const String IMG_KEY = 'IMAGE_KEY';
  static bool invalidEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return true;
    } else{
      return false;
    }
  }
  ///Token
  static Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> recuperarToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  ///Salvar User
  static Future<void> salvarUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }
  ///Salvar manter Conectado
  static Future<void> salvarManterConectado(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boolKey, valor);
  }
  ///Ler manter Conectado
  static Future<bool> recuperarManterConectado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_boolKey) ?? false; // false como default
  }
  ///Recuperar User
  static Future<User?> recuperarUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }
  ///Remover User
  static Future<void> removerUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
  static String generateDataHora(DateTime data, int horas, int minutos){
    return DateTime(data.year, data.month, data.day, horas, minutos, 10).toIso8601String();
  }

  static int generateHourOfDate(String? dataString){
    DateTime data = DateTime.parse(dataString!);
    return data.hour;
  }

  static int generateMinutesOfDate(String? dataString){
    DateTime data = DateTime.parse(dataString!);
    return data.minute;
  }

  static String generateDataHoraSpring(){
    return DateTime.now().toIso8601String();
  }
   static Future<bool> isConnected() async {
    bool flag = false;
      try {
        final result = await InternetAddress.lookup('globo.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          flag = true;
          print('connected');
        }
        } on SocketException catch (_) {

        print('not connected');
        flag = false;
        }
        return flag;
    }

  ///DataHora
  static String getDataHora(){
    return DateTime.now().toIso8601String();
  }
  static DateTime? stringToDate(String dataHora){
    return DateTime.tryParse(dataHora);
  }
  static String formatarData(String data, bool small){

    final DateTime dt = DateTime.parse(data);

    final String dia = dt.day.toString().padLeft(2, '0');
    final String mes = dt.month.toString().padLeft(2, '0');
    final String ano = dt.year.toString();
    final String hora = dt.hour.toString().padLeft(2, '0');
    final String minuto = dt.minute.toString().padLeft(2, '0');

    return small
        ? "$dia/$mes/$ano"
        : "$dia/$mes/$ano $hora:$minuto";

  }
  ///Mostrar Texto
  static void showDefaultSnackbar(BuildContext context, String texto){
  //Scaffold.of(context).showSnackBar(
    final snackBar = SnackBar(
      content: Text((texto.isEmpty) ? "" : texto.toString()),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
  );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static Future<String> base64String(Future<Uint8List> bytes) async {
    return base64Encode(await bytes);
  }
  static String formatarDateTime(DateTime? data){
      if(data != null ){
        if(data.month < 10 && data.day < 10){
          return '0${data.day}/0${data.month}/${data.year}';
        }else if(data.day >= 10 && data.month < 10){
          return '${data.day}/0${data.month}/${data.year}';
        }else if(data.day < 10 && data.month >= 10){
          return '0${data.day}/${data.month}/${data.year}';
        }else{
          return '${data.day}/${data.month}/${data.year}';
        }
      }
      return data.toString();
  }

  static SizedBox sizedBox({double largura = 0, double altura = 0}) {
    return SizedBox(
      width: largura,
      height: altura,
    );
  }
  static Image imageFromBase64String(String bytes){
    return Image.memory(

        base64Decode(bytes),
        height: 80.0,
        width: 80.0,
        fit: BoxFit.fill,
        alignment: Alignment.center,

        );
  }
  static Uint8List fileFromBase64String(String bytes)=> base64.decode(bytes);
  static String base64DecodeString(String input) => utf8.decode(base64.decode(input));
  static String base64EncodeString(String input) => base64.encode(utf8.encode(input));

  static Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }
  /// Função que retorna a plataforma usada pelo Codigo
  static AppPlatform getCurrentPlatform() {
    if (kIsWeb) {
      return AppPlatform.web;
    }

    if (Platform.isAndroid) return AppPlatform.android;
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isWindows) return AppPlatform.windows;
    if (Platform.isLinux) return AppPlatform.linux;
    if (Platform.isMacOS) return AppPlatform.macos;
    if (Platform.isFuchsia) return AppPlatform.fuchsia;

    return AppPlatform.unknown;
  }

  static imgUrlFinish(String url){
      AppPlatform plataforma = Utils.getCurrentPlatform();
      String baseImg = plataforma == AppPlatform.android ? Utils.URL_IMG_ANDROID : Utils.URL_IMG_WEB;
     return '''$baseImg$url''';
    }

    static String capitalizeFirstLetter(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    static String mouthYearFormated(){
      DateTime agora = DateTime.now();
      return DateFormat("MM/yyyy").format(agora);
    }

    static  Future<Map<String, String>> requestToken() async {
      var token = await recuperarToken();
      return { 'Authorization': 'Bearer $token' };
    }
    static String dateFirstOrLast(bool firstDay){

      DateTime data;
      DateTime now = DateTime.now();
      if(firstDay){
        data = DateTime(now.year, now.month, 1);
      }else{
        data = DateTime(now.year, now.month + 1, 0);
      }
      return data.toIso8601String().split('T').first;

    }
  }














































