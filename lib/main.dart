import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:controle_de_gastos_app/ui/core/constants/routes/app_routes.dart';
import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/data/service/notifications/notifications.dart';
import 'package:controle_de_gastos_app/ui/data/service/worker/alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_handler/share_handler.dart';

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ShareHandlerPlatform _shareHandler = ShareHandler.instance;
  SharedMedia? _sharedMedia;

  _sharedMedia = _shareHandler.sharedMedia;

// Caso o app já esteja aberto
  _shareHandler.sharedMediaStream.listen((media) {
      _sharedMedia = media;

  });


  final media = _sharedMedia!;

  if (media.content?.isNotEmpty == true) {
    print('Texto recebido:\n\n${media.content}');
  }


  ///Serviços
  await Notifications.initNotifications();
  await AndroidAlarmManager.initialize();
  await AlarmManager.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

extension on ShareHandlerPlatform {
  SharedMedia? get sharedMedia => null;
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


