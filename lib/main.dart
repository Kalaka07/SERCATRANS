import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí deberías verificar el estado de autenticación
    bool isLoggedIn =
        false; // Suponiendo que obtienes este estado de alguna lógica

    if (isLoggedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
