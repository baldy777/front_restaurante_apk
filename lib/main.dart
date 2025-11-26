import 'package:app_movil/components/navbar.dart';
import 'package:app_movil/pages/usuarios/login.dart';
import 'package:app_movil/pages/usuarios/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Restaurante',
      theme: ThemeData(primarySwatch: Colors.red),

      routes: {
        '/login': (context) => const LoginForm(),
        '/register': (context) => RegisterForm(),
        '/navbar': (context) => const Navbar(),
      },
      initialRoute: '/login',
    );
  }
}
