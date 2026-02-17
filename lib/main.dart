import 'package:controle_de_gastos_app/ui/core/constants/routes/app_routes.dart';
import 'package:controle_de_gastos_app/ui/core/notifications/notifications.dart';
import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
      await chamarApi();

    return Future.value(true);
  });
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notifications.initNotifications();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // útil para ver logs
  );

  await Workmanager().registerOneOffTask(
    "chamadaApiTask",
    "chamadaApi",
    initialDelay: Duration(seconds: 10), // teste rápido
  );






  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point') // ADICIONE ISSO AQUI TAMBÉM
Future<void> chamarApi() async {
  print("WORKER RODOU COM SUCESSO");
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
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
    );
  }
}


