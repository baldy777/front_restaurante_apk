import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/services/auth_service.dart';
import 'package:flutter/material.dart';

class UserPerfilVista extends StatefulWidget {
  const UserPerfilVista({super.key});

  @override
  State<UserPerfilVista> createState() => _UserPerfilVistaState();
}

class _UserPerfilVistaState extends State<UserPerfilVista> {
  final AuthService authService = AuthService();
  Map<String, dynamic>? usuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final datos = await authService.obtenerDatosUsuario();
    setState(() {
      usuario = datos;
      isLoading = false;
    });
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await authService.cerrarSesion();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: ColoresStyle.fondo,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (usuario == null) {
      return Scaffold(
        backgroundColor: ColoresStyle.fondo,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No se pudo cargar la información del usuario'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Volver al login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: ColoresStyle.acento,
              child: Text(
                usuario!['nombre'] != null && usuario!['nombre'].isNotEmpty
                    ? usuario!['nombre'][0].toUpperCase()
                    : 'U',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              usuario!['nombre'] ?? 'Usuario',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              usuario!['rol'] ?? 'Sin rol',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                      subtitle: Text(usuario!['correo'] ?? 'No disponible'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.purple,
                      ),
                      title: const Text("Rol"),
                      subtitle: Text(usuario!['rol'] ?? 'No disponible'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // // Botón para editar perfil
            // ElevatedButton.icon(
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Función en desarrollo")),
            //     );
            //   },
            //   icon: const Icon(Icons.edit),
            //   label: const Text("Editar perfil"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: ColoresStyle.acento,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 30,
            //       vertical: 12,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),

            // Botón para cerrar sesión
            OutlinedButton.icon(
              onPressed: _cerrarSesion,
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar sesión"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
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
