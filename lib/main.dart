import 'package:controle_de_gastos_app/ui/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() async {

  runApp(
    MaterialApp(
      title: 'Controle de Gastos',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.login,
    )
  );

}


