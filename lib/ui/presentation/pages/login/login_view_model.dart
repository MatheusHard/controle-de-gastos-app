import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';

import '../../../core/utils/utils.dart';
import '../../../data/model/user.dart';
import '../../../data/service/api/login_api.dart';

class LoginViewModel extends ChangeNotifier {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isLoading = false;
  bool isHomologacao = false;
  bool manterConectado = false;
  bool obscured = true;

  String email = "";
  String senha = "";

  Future<void> init(BuildContext context) async {
    await loadUser();
    await loadAmbiente();
    await loadConectado();

    getFileByShare();

    notifyListeners();
  }

  Future<void> loadAmbiente() async {
    bool isProd = await Utils.getIsProd();

    isHomologacao = !isProd;
    notifyListeners();
  }

  Future<void> loadUser() async {
    User? user = await Utils.recuperarUser();

    if (user != null) {
      email = user.username ?? "";
      senha = user.password ?? "";

      emailController.text = email;
      passwordController.text = senha;
    }

    notifyListeners();
  }

  Future<void> loadConectado() async {
    manterConectado =
    await Utils.recuperarManterConectado();

    notifyListeners();
  }

  void toggleObscured() {
    obscured = !obscured;
    notifyListeners();
  }

  void changeManterConectado(bool value) {
    manterConectado = value;
    notifyListeners();
  }

  void changeEmail(String value) {
    email = value;
  }

  void changePassword(String value) {
    senha = value;
  }

  Future<void> login(BuildContext context) async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    await LoginApi(context)
        .login(email, senha, manterConectado);

    isLoading = false;
    notifyListeners();
  }

  void changeAmbiente(bool value) {
    isHomologacao = value;
    notifyListeners();
  }

  void getFileByShare() {
    final handler = ShareHandler.instance;

    handler.sharedMediaStream.listen((media) {
      Utils.handleSharedMedia(media);
    });

    handler.getInitialSharedMedia().then((media) {
      if (media != null) {
        Utils.handleSharedMedia(media);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }
}