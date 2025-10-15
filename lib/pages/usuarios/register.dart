import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // String? _sexoSeleccionado;
  String? _paisSeleccionado;

  // final List<String> _sexos = ["Masculino", "Femenino", "Otro"];
  final List<String> _paises = ["Bolivia", "Argentina", "Chile", "Perú"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crea una cuenta", style: TextStyle(fontFamily: "arial")),
        backgroundColor: ColoresStyle.fondo,
      ),
      backgroundColor: ColoresStyle.fondo,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Nombre completo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Nombre de Usuario",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Correo Electrónico",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirmar Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            // SizedBox(height: 20),
            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     labelText: "Sexo",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   initialValue: _sexoSeleccionado,
            //   items: _sexos.map((sexo) {
            //     return DropdownMenuItem(value: sexo, child: Text(sexo));
            //   }).toList(),
            //   onChanged: (valor) {
            //     setState(() {
            //       _sexoSeleccionado = valor;
            //     });
            //   },
            // ),

            // 🔹 Dropdown de País
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "País",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              initialValue: _paisSeleccionado,
              items: _paises.map((pais) {
                return DropdownMenuItem(value: pais, child: Text(pais));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  _paisSeleccionado = valor;
                });
              },
            ),

            // Botón registrar
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
