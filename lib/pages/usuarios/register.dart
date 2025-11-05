import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmarPasswordCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _fechaNacimientoCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _usuarioCtrl.dispose();
    _correoCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmarPasswordCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _fechaNacimientoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crea una cuenta", style: TextoStyle.titulo),
        backgroundColor: ColoresStyle.fondo,
      ),
      backgroundColor: ColoresStyle.fondo,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                style: TextoStyle.contenido,
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  hintText: "Nombre completo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese su nombre completo" : null,
              ),

              const SizedBox(height: 20),
              TextFormField(
                style: TextoStyle.contenido,
                controller: _usuarioCtrl,
                decoration: const InputDecoration(
                  hintText: "Apellidos Paterno y Materno",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese un nombre de usuario" : null,
              ),

              const SizedBox(height: 20),
              TextFormField(
                style: TextoStyle.contenido,
                controller: _correoCtrl,
                decoration: const InputDecoration(
                  hintText: "Correo Electrónico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un correo electrónico";
                  }
                  if (!value.contains('@')) return "Correo inválido";
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                style: TextoStyle.contenido,
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese una contraseña";
                  }
                  if (value.length < 6) {
                    return "Debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                style: TextoStyle.contenido,
                controller: _confirmarPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirmar Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordCtrl.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _telefonoCtrl,
              //   keyboardType: TextInputType.phone,
              //   decoration: const InputDecoration(
              //     hintText: "Número de teléfono",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) =>
              //       value!.isEmpty ? "Ingrese su número de teléfono" : null,
              // ),
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _fechaNacimientoCtrl,
              //   readOnly: true,
              //   decoration: const InputDecoration(
              //     hintText: "Fecha de nacimiento",
              //     border: OutlineInputBorder(),
              //   ),
              //   onTap: () async {
              //     DateTime? fecha = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime(2000),
              //       firstDate: DateTime(1900),
              //       lastDate: DateTime.now(),
              //     );
              //     if (fecha != null) {
              //       setState(() {
              //         _fechaNacimientoCtrl.text =
              //             "${fecha.day}/${fecha.month}/${fecha.year}";
              //       });
              //     }
              //   },
              //   validator: (value) =>
              //       value!.isEmpty ? "Seleccione su fecha de nacimiento" : null,
              // ),
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _direccionCtrl,
              //   decoration: const InputDecoration(
              //     hintText: "Dirección",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) =>
              //       value!.isEmpty ? "Ingrese su dirección" : null,
              // ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registro exitoso")),
                    );
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
