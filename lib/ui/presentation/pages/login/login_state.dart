class LoginState {
  final bool isLoading;
  final bool isHomologacao;
  final bool manterConectado;
  final bool obscured;

  LoginState({
    this.isLoading = false,
    this.isHomologacao = false,
    this.manterConectado = false,
    this.obscured = true,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isHomologacao,
    bool? manterConectado,
    bool? obscured,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isHomologacao: isHomologacao ?? this.isHomologacao,
      manterConectado:
      manterConectado ?? this.manterConectado,
      obscured: obscured ?? this.obscured,
    );
  }
}