import 'package:app_movil/services/usuario_service.dart';
import 'package:flutter/material.dart';

void mostrarModalAgregarUsuario(BuildContext context) {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController apellidoPaternoCtrl = TextEditingController();
  final TextEditingController apellidoMaternoCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController contrasenaCtrl = TextEditingController();

  int? rolSeleccionado;

  final api = UsuarioApiPost();

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
                const Text(
                  "Agregar usuario",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    labelText: "Contraseña",
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

                        try {
                          final nuevoUsuario = await api.crearUsuario(
                            nombre: nombreCtrl.text,
                            apellidoPaterno: apellidoPaternoCtrl.text,
                            apellidoMaterno: apellidoMaternoCtrl.text,
                            correo: correoCtrl.text,
                            contrasena: contrasenaCtrl.text,
                            telefono: telefonoCtrl.text,
                            rolId: rolSeleccionado!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Usuario agregado correctamente",
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior
                                  .floating, // Hace que no esté pegado al bottom
                              margin: const EdgeInsets.fromLTRB(
                                20,
                                20,
                                20,
                                0,
                              ), // Margen superior
                              duration: const Duration(
                                seconds: 2,
                              ), // Opcional: duración del mensaje
                            ),
                          );

                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
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
