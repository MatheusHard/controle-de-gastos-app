import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gradients/app_gradients.dart';

class ThemeProvider extends ChangeNotifier {
  static const _gradientKey = 'selected_theme_gradient';
  final SharedPreferences _preferences;

  ThemeProvider(this._preferences) {
    final savedGradient = _preferences.get(_gradientKey);
    if (savedGradient is String &&
        RegExp(r'^color:[0-9a-fA-F]{8}$').hasMatch(savedGradient)) {
      final color = Color(int.parse(savedGradient.substring(6), radix: 16));
      _customColor = color;
      _currentGradient = LinearGradient(colors: [color, color]);
      return;
    }
    _currentGradient =
        AppGradients.getAllGradients()[savedGradient] ??
        AppGradients.blackPurpleGradient;
  }

  Gradient _currentGradient = AppGradients.blackPurpleGradient;
  Gradient get currentGradient => _currentGradient;
  Color? _customColor;
  Color? get customColor => _customColor;

  Future<void> setColor(Color color) async {
    final opaqueColor = color.withValues(alpha: 1);
    _customColor = opaqueColor;
    _currentGradient = LinearGradient(colors: [opaqueColor, opaqueColor]);
    notifyListeners();
    await _preferences.setString(
      _gradientKey,
      'color:${opaqueColor.toARGB32().toRadixString(16).padLeft(8, '0')}',
    );
  }

  Future<void> setGradient(Gradient gradient) async {
    final name = AppGradients.getAllGradients().entries
        .firstWhere((entry) => entry.value == gradient)
        .key;
    _currentGradient = gradient;
    _customColor = null;
    notifyListeners();
    await _preferences.setString(_gradientKey, name);
  }
}
