import 'package:app_movil/components/modalAgregarUsuario.dart';
import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/models/usuarios.dart';
import 'package:app_movil/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Agregado para SharedPreferences

class EmpleadosVista extends StatefulWidget {
  const EmpleadosVista({super.key});

  @override
  State<EmpleadosVista> createState() => _EmpleadosVistaState();
}

class _EmpleadosVistaState extends State<EmpleadosVista> {
  final UsuarioApiGet apiService = UsuarioApiGet();

  // Variables para rol de usuario
  String? _rolUsuario;
  bool _esAdmin = false;
  bool _cargandoRol = true;

  @override
  void initState() {
    super.initState();
    _cargarRol();
  }

  // Cargar el rol del usuario desde SharedPreferences
  Future<void> _cargarRol() async {
    setState(() => _cargandoRol = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final rol = prefs.getString('userRol') ?? 'Usuario';

      setState(() {
        _rolUsuario = rol;
        _esAdmin =
            rol.toLowerCase() ==
            'admin'; // Asumiendo que 'admin' es el rol de administrador
        _cargandoRol = false;
      });
    } catch (e) {
      setState(() => _cargandoRol = false);
      _mostrarError('Error al cargar rol de usuario: $e');
    }
  }

  // Función para editar usuario (solo admin)
  void _editarUsuario(Usuarios usuario) {
    if (!_esAdmin) return;

    mostrarModalAgregarUsuario(
      context,
      usuario: usuario,
    ); // Asumiendo que el modal puede recibir un usuario para editar
  }

  // Función para eliminar usuario (solo admin)
  Future<void> _eliminarUsuario(Usuarios usuario) async {
    if (!_esAdmin) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar empleado'),
        content: Text(
          '¿Estás seguro de eliminar a "${usuario.nombre} ${usuario.apellidoPaterno}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        // Asumiendo que hay un método en UsuarioApiGet para eliminar
        await apiService.eliminarUsuario(
          usuario.id,
        ); // Ajusta si el método es diferente
        setState(() {}); // Refrescar la vista
        _mostrarMensaje('Empleado eliminado correctamente', Colors.green);
      } catch (e) {
        _mostrarError('Error al eliminar empleado: $e');
      }
    }
  }

  // Mostrar mensaje de éxito
  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Mostrar mensaje de error
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoRol) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gestión de empleados', style: TextoStyle.contenido),
              const SizedBox(height: 20),

              FutureBuilder<List<Usuarios>>(
                future: apiService.obtenerUsuarios(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final usuarios = snapshot.data ?? [];

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: usuarios.map((empleado) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 44) / 2,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${empleado.nombre} ${empleado.apellidoPaterno}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  empleado.rol,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Tel: ${empleado.telefono}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Mostrar botones solo si es admin
                                if (_esAdmin)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            _editarUsuario(empleado),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _eliminarUsuario(empleado),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Botón flotante solo para admin
      floatingActionButton: _esAdmin
          ? FloatingActionButton(
              onPressed: () {
                mostrarModalAgregarUsuario(context);
              },
              backgroundColor: ColoresStyle.acento,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
