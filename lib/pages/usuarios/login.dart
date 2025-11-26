import 'package:flutter/material.dart';
import 'package:app_movil/services/auth_service.dart';
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
  bool _isLoading = false;

  Future<void> iniciarSesion() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    print("Iniciando sesión ======================================");
    print("correo recibido: ${correoCtrl.text}");

    final correo = correoCtrl.text.trim();
    final contrasena = contrasenaCtrl.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final respuesta = await authService.login(correo, contrasena);

    print("respuesta del login: $respuesta");

    setState(() => _isLoading = false);

    if (respuesta != null && respuesta['token'] != null) {
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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Correo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: contrasenaCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : iniciarSesion,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      ColoresStyle.acento,
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Iniciar Sesión",
                          style: TextoStyle.contenido,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    correoCtrl.dispose();
    contrasenaCtrl.dispose();
    super.dispose();
  }
}
