import 'package:flutter/material.dart';
class RegisterPage extends StatelessWidget {
  static final String route = 'register';
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Login Page'),
        ),
      ),
    );
  }
}