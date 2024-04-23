class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado!',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente novamente mais tarde',
    'EMAIL_NOT_FOUND': 'Email não encontrado',
    'INVALID_LOGIN_CREDENTIALS': 'Senha invalida',
    'USER_DISABLED': 'A conta de usuário foi desativada',
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro na autenticação!';
  }
}
