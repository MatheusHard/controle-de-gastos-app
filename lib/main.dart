
import 'package:controle_de_gastos_app/ui/feature/view/home_page.dart';
import 'package:controle_de_gastos_app/ui/feature/view/login_page.dart';
import 'package:flutter/material.dart';

void main() async {




  runApp(
  MaterialApp(
    title: 'Agendamento Manicure',
    debugShowCheckedModeBanner: false,
    routes: {
      '/home_page': (BuildContext context) => HomePage(),
      '/login_page': (BuildContext context) => LoginPage()
    /*  '/home_page': (BuildContext context) => HomePage(null),
      '/cliente_page': (BuildContext context) => ClientePage(null),
      '/agendamento_page': (BuildContext context) => AgendamentoPage(null),
      '/login_page': (BuildContext context) =>  LoginPage(),
      '/pix_page': (BuildContext context) =>  PixPage(),*/

    },
    initialRoute: '/login_page',
  )

  );
}


