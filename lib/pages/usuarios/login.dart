import 'package:flutter/material.dart';
import 'package:app_movil/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_movil/core/colores_style.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController contrasenaCtrl = TextEditingController();
  final AuthService authService = AuthService();

  Future<void> iniciarSesion() async {
    print("Iniciando sesión ======================================");
    print("correro recibido: ${correoCtrl.text}");
    print("contrasena recibida: ${contrasenaCtrl.text}");

    final correo = correoCtrl.text.trim();
    final contrasena = contrasenaCtrl.text.trim();

    final respuesta = await authService.login(correo, contrasena);

    print("respuesta del login: $respuesta");

    if (respuesta != null && respuesta['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', respuesta['token']);
      Navigator.pushReplacementNamed(context, '/navbar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido, por favor inicia sesión",
                style: TextStyle(fontFamily: "arial", fontSize: 23),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: correoCtrl,
                decoration: const InputDecoration(
                  hintText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: contrasenaCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: iniciarSesion,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(ColoresStyle.acento),
                ),
                child: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("¿No estás registrado? Crea una cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
