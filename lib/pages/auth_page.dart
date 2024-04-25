import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.purpleAccent,
                  Colors.deepPurpleAccent,
                  Colors.deepPurple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 70,
                      ),
                      transform: Matrix4.rotationZ(-8 * 3.1415926535 / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: Text(
                        'Minha Loja',
                        style: TextStyle(
                          fontSize: 45,
                          fontFamily: 'Anton',
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
