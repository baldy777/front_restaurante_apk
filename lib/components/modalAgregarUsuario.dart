import 'package:app_movil/models/usuarios.dart';
import 'package:app_movil/services/usuario_service.dart';
import 'package:flutter/material.dart';

void mostrarModalAgregarUsuario(
  BuildContext context, {
  Usuarios? usuario,
  VoidCallback? onGuardado,
}) {
  final TextEditingController nombreCtrl = TextEditingController(
    text: usuario?.nombre ?? '',
  );
  final TextEditingController apellidoPaternoCtrl = TextEditingController(
    text: usuario?.apellidoPaterno ?? '',
  );
  final TextEditingController apellidoMaternoCtrl = TextEditingController(
    text: usuario?.apellidoMaterno ?? '',
  );
  final TextEditingController telefonoCtrl = TextEditingController(
    text: usuario?.telefono ?? '',
  );
  final TextEditingController correoCtrl = TextEditingController(
    text: usuario?.correo ?? '',
  );
  final TextEditingController contrasenaCtrl =
      TextEditingController(); // Dejar vacío en edición por seguridad

  // Mapeo de rol string a ID (basado en el dropdown)
  int? rolSeleccionado;
  if (usuario != null) {
    switch (usuario.rol.toLowerCase()) {
      case 'administrador':
        rolSeleccionado = 1;
        break;
      case 'usuario':
        rolSeleccionado = 2;
        break;
      case 'cocinero':
        rolSeleccionado = 3;
        break;
      default:
        rolSeleccionado = null;
    }
  }

  final apiPost = UsuarioApiPost();
  final apiGet = UsuarioApiGet(); // Para editar

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  usuario == null ? "Agregar usuario" : "Editar usuario",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: apellidoPaternoCtrl,
                  decoration: InputDecoration(
                    labelText: "Apellido Paterno",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: apellidoMaternoCtrl,
                  decoration: InputDecoration(
                    labelText: "Apellido Materno",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: telefonoCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Teléfono",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: correoCtrl,
                  decoration: InputDecoration(
                    labelText: "Correo",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: contrasenaCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: usuario == null
                        ? "Contraseña"
                        : "Nueva Contraseña (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // DROPDOWN DE ROLES
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Rol",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: rolSeleccionado,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Administrador")),
                    DropdownMenuItem(value: 2, child: Text("Usuario")),
                    DropdownMenuItem(value: 3, child: Text("Cocinero")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      rolSeleccionado = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (rolSeleccionado == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Selecciona un rol")),
                          );
                          return;
                        }

                        // Validar campos obligatorios
                        if (nombreCtrl.text.isEmpty ||
                            apellidoPaternoCtrl.text.isEmpty ||
                            apellidoMaternoCtrl.text.isEmpty ||
                            telefonoCtrl.text.isEmpty ||
                            correoCtrl.text.isEmpty ||
                            (usuario == null && contrasenaCtrl.text.isEmpty)) {
                          // Contraseña obligatoria solo en creación
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Completa todos los campos obligatorios",
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          if (usuario == null) {
                            // Agregar nuevo usuario
                            await apiPost.crearUsuario(
                              nombre: nombreCtrl.text,
                              apellidoPaterno: apellidoPaternoCtrl.text,
                              apellidoMaterno: apellidoMaternoCtrl.text,
                              correo: correoCtrl.text,
                              contrasena: contrasenaCtrl.text,
                              telefono: telefonoCtrl.text,
                              rolId: rolSeleccionado!,
                            );
                          } else {
                            // Editar usuario existente
                            final usuarioData = {
                              "nombre": nombreCtrl.text,
                              "apellidoPaterno": apellidoPaternoCtrl.text,
                              "apellidoMaterno": apellidoMaternoCtrl.text,
                              "telefono": telefonoCtrl.text,
                              "correo": correoCtrl.text,
                              "rolesIds": [rolSeleccionado!], // Actualizar rol
                            };
                            if (contrasenaCtrl.text.isNotEmpty) {
                              usuarioData["contrasena"] =
                                  contrasenaCtrl.text; // Solo si se cambió
                            }
                            await apiGet.actualizarUsuario(
                              usuario.id,
                              usuarioData,
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                usuario == null
                                    ? "Usuario agregado correctamente"
                                    : "Usuario actualizado correctamente",
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          onGuardado?.call(); // Refrescar la vista
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            ),
                          );
                        }
                      },
                      child: const Text("Guardar"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
