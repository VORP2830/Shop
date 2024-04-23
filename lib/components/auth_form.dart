import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if(!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);
    if(_isLogin()) {
      await auth.signIn(
        _authData['email']!,
        _authData['password']!,
      );
    } else {
      await auth.signUp(
        _authData['email']!,
        _authData['password']!,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 310 : 400,
          width: deviceSize.width * 0.75,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _authData['email'] = value ?? '',
                  validator: (value) {
                    final email = value ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: _passwordController,
                  validator: _isLogin()
                      ? null
                      : (value) {
                          final password = value ?? '';
                          if (password.isEmpty || password.length < 5) {
                            return 'Informe uma senha válida';
                          }
                          return null;
                        },
                  onSaved: (value) => _authData['password'] = value ?? '',
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      final password = value ?? '';
                      if (password != _passwordController.text) {
                        return 'Senhas são diferentes';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      foregroundColor: Theme.of(context).colorScheme.background,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                Spacer(),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI UMA CONTA?',
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
