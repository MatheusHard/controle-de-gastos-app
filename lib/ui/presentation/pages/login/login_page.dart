import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/imgs/img_url.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../widgets/buttons/normal_button/login_button.dart';
import '../../widgets/checkboxes/manter_conectado_check.dart';
import '../../widgets/images/logo_img.dart';
import '../../widgets/inputs/email_field.dart';
import '../../widgets/inputs/password_field.dart';
import 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel()..init(context),

      child: Consumer<LoginViewModel>(
        builder: (context, vm, child) {

          return Scaffold(
            backgroundColor:
            vm.isHomologacao
                ? Colors.yellow.shade100
                : null,

            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Form(
                    key: vm.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [

                          /// Ambiente homologação
                          if (vm.isHomologacao)
                            const Padding(
                              padding:
                              EdgeInsets.only(bottom: 10),
                              child: Text(
                                "AMBIENTE HOMOLOGAÇÃO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                          /// Logo
                          LogoImg(
                            width: MediaQuery.of(context).size.width,
                            tamanho: 3,
                            url: ImgUrl.gasto_financeiro,
                            onChangeAmbiente: vm.changeAmbiente,
                          ),

                          Utils.sizedBox(
                            altura: 30.0,
                          ),

                          /// Email
                          EmailField(
                            controller: vm.emailController,
                            focusNode: vm.emailFocus,
                            onChanged: vm.changeEmail,
                          ),

                          Utils.sizedBox(
                            altura: 30.0,
                          ),

                          /// Senha
                          PasswordField(
                            controller: vm.passwordController,
                            focusNode: vm.passwordFocus,
                            obscured: vm.obscured,
                            onToggleObscured: vm.toggleObscured,
                            onChanged: vm.changePassword,
                          ),

                          Utils.sizedBox(
                            altura: 30.0,
                          ),

                          /// Login
                          LoginButton(
                            onTap: () => vm.login(context),
                            isLoading: vm.isLoading,
                            label: "Acessar",
                            icon: Icons.account_circle_rounded,
                            gradient: context.watch<ThemeProvider>().currentGradient,
                            textStyle: AppTextStyles.textLogin,
                            height: 55,
                            radios: 20,
                          ),

                          /// Manter conectado
                          ManterConectadoCheck(
                            value: vm.manterConectado,
                            onChanged: (value) {
                              vm.changeManterConectado(
                                value ?? false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}