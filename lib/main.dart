import 'package:controle_de_gastos_app/ui/feature/pages/home_page.dart';
import 'package:controle_de_gastos_app/ui/feature/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() async {

  runApp(
    MaterialApp(
      title: 'Controle de Gastos',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home_page': (BuildContext context) => HomePage(),
        '/login_page': (BuildContext context) => LoginPage()
      },
      initialRoute: '/login_page',
    )
  );

}


