import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 230, 225),
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

              const TextField(
                decoration: InputDecoration(
                  hintText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Ingrese su Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.deepOrangeAccent),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
                child: const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontFamily: "arial",
                    fontSize: 18,
                    color: Color.fromARGB(255, 236, 230, 225),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  "¿No estás registrado? Crea una cuenta",
                  style: TextStyle(
                    fontFamily: "arial",
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
