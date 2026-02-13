import 'package:controle_de_gastos_app/ui/core/constants/routes/app_routes.dart';
import 'package:controle_de_gastos_app/ui/core/notifications/notifications.dart';
import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notifications.initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Provider do tema
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
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

    );
  }
}