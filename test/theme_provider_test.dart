import 'package:controle_de_gastos_app/ui/core/theme/gradients/app_gradients.dart';
import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses the default gradient when no preference exists', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final provider = ThemeProvider(preferences);
    addTearDown(provider.dispose);

    expect(provider.currentGradient, AppGradients.blackPurpleGradient);
  });

  test(
    'persists every available gradient and restores it on startup',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final provider = ThemeProvider(preferences);
      addTearDown(provider.dispose);
      var notifications = 0;
      provider.addListener(() => notifications++);

      for (final entry in AppGradients.getAllGradients().entries) {
        await provider.setGradient(entry.value);
        expect(preferences.getString('selected_theme_gradient'), entry.key);

        final restoredProvider = ThemeProvider(preferences);
        expect(restoredProvider.currentGradient, entry.value);
        restoredProvider.dispose();
      }

      expect(notifications, AppGradients.getAllGradients().length);
    },
  );

  test('falls back to the default for an unknown saved gradient', () async {
    SharedPreferences.setMockInitialValues({
      'selected_theme_gradient': 'removed_gradient',
    });
    final preferences = await SharedPreferences.getInstance();
    final provider = ThemeProvider(preferences);
    addTearDown(provider.dispose);

    expect(provider.currentGradient, AppGradients.blackPurpleGradient);
  });
}
