import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../../data/model/user.dart';

class HomeViewModel extends ChangeNotifier {

  User? user;

  bool isLoading = false;

  Future<void> init() async {
    await loadingUser();
  }

  Future<void> loadingUser() async {
    isLoading = true;
    notifyListeners();

    try {
      user = await Utils.recuperarUser();
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}