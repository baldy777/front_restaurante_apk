import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class UserPerfilVista extends StatefulWidget {
  const UserPerfilVista({super.key});

  @override
  State<UserPerfilVista> createState() => _UserPerfilVistaState();
}

class _UserPerfilVistaState extends State<UserPerfilVista> {
  // Datos de ejemplo del usuario
  final Map<String, String> usuario = {
    "nombre": "Carlos Pérez",
    "email": "carlos.perez@email.com",
    "telefono": "71234567",
    "rol": "Administrador",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: ColoresStyle.acento,
              child: Text(
                usuario['nombre']![0], // Primera letra del nombre
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              usuario['nombre']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usuario['rol']!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Información del usuario en card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text("Correo electrónico"),
                      subtitle: Text(usuario['email']!),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: const Text("Teléfono"),
                      subtitle: Text(usuario['telefono']!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón para editar perfil
            ElevatedButton.icon(
              onPressed: () {
                // Abrir modal o navegación para editar perfil
              },
              icon: const Icon(Icons.edit),
              label: const Text("Editar perfil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresStyle.acento,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
