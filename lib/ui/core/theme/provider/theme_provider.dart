import 'package:flutter/material.dart';
import '../gradients/app_gradients.dart';

class ThemeProvider extends ChangeNotifier {
  LinearGradient _currentGradient = AppGradients.blackPurpleGradient;
  LinearGradient get currentGradient => _currentGradient;
  void setGradient(LinearGradient gradient) {
    _currentGradient = gradient;
    notifyListeners();
  }
}