import 'package:flutter/material.dart';
import 'package:controle_de_gastos_app/ui/core/theme/provider/theme_provider.dart';
import 'package:controle_de_gastos_app/ui/core/theme/gradients/app_gradients.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';

import '../../../data/repositories/perfil_repository.dart';

class PerfilViewModel extends ChangeNotifier {

  final PerfilRepository repository;

  PerfilViewModel({
    required this.repository,
  });

  User? _user;
  User? get user => _user;

  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final gradients = AppGradients.getAllGradients().entries.toList();

  Future<void> init() async {
    await carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await repository.recuperarUsuario();
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os dados do usuário.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selecionarGradiente(
    int index,
    ThemeProvider themeProvider,
  ) {
    _selectedIndex = index;
    final entry = gradients[index];
    themeProvider.setGradient(entry.value);
    notifyListeners();
  }
}