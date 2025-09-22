import 'package:app_movil/pages/login.dart';
import 'package:app_movil/pages/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/' 
        '/login': (context) => const LoginForm(),
        '/register': (context) => RegisterForm(), // Define RegisterForm in register.dart
      },
      initialRoute: '/login',
      home: const Scaffold(
        body: LoginForm(),
      ),
    );
  }
}
