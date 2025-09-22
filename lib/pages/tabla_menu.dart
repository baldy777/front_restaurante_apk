import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

//esta vista falta enrutar en el main.dart y en el login.dart
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Crea una cuenta", style: TextStyle(fontFamily: "arial")),
        backgroundColor: const Color.fromARGB(255, 236, 230, 225),
      ),
      backgroundColor: const Color.fromARGB(255, 236, 230, 225),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //ver como poner una barra inferior donde estaran las opciones de la app
            
            //hay que posicionar el boton, el boton es para agregar pedidos
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
