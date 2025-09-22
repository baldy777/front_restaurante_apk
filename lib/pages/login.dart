import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 236, 230, 225),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bienvenido, por favor inicia sesión",
            style: TextStyle(fontFamily: "arial", fontSize: 23),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nombre de Usuario',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ingrese su Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(onPressed: () {}, 
          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.deepOrangeAccent)), 
          child: const Text("Iniciar Sesión", style: TextStyle(fontFamily: "arial", fontSize: 18, 
          color:  Color.fromARGB(255, 236, 230, 225),))),


          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text(
              "¿No estas registrado? Crea una cuenta",
              style: TextStyle(
                fontFamily: "arial",
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
