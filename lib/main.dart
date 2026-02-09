import 'package:controle_de_gastos_app/ui/core/constants/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(
    MaterialApp(
      title: 'Controle de Gastos',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // português Brasil
        Locale('en', 'US'), // inglês (fallback)
      ],
    ),
  );
}