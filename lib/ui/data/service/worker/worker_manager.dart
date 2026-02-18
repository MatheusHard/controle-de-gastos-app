
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  // Inicializa o Workmanager
  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // útil para logs
    );
  }

  // Registra uma tarefa
  static Future<void> registerOneOffTask() async {
    await Workmanager().registerOneOffTask(
      "chamadaApiTask",
      "chamadaApi",
      initialDelay: const Duration(seconds: 10),
    );
  }
}

/// Dispatcher que será chamado pelo Workmanager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await chamarApi();
    return Future.value(true);
  });
}

/// Função que simula chamada de API
@pragma('vm:entry-point')
Future<void> chamarApi() async {
  print("WORKER RODOU COM SUCESSO");
}
