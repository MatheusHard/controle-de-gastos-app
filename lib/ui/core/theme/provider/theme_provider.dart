import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gradients/app_gradients.dart';

class ThemeProvider extends ChangeNotifier {
  static const _gradientKey = 'selected_theme_gradient';
  final SharedPreferences _preferences;

  ThemeProvider(this._preferences) {
    final savedGradient = _preferences.get(_gradientKey);
    _currentGradient =
        AppGradients.getAllGradients()[savedGradient] ??
        AppGradients.blackPurpleGradient;
  }

  LinearGradient _currentGradient = AppGradients.blackPurpleGradient;
  LinearGradient get currentGradient => _currentGradient;
  Future<void> setGradient(LinearGradient gradient) async {
    final name = AppGradients.getAllGradients().entries
        .firstWhere((entry) => entry.value == gradient)
        .key;
    _currentGradient = gradient;
    notifyListeners();
    await _preferences.setString(_gradientKey, name);
  }
}
