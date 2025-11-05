import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class EmpleadosVista extends StatefulWidget {
  const EmpleadosVista({super.key});

  @override
  State<EmpleadosVista> createState() => _EmpleadosVistaState();
}

class _EmpleadosVistaState extends State<EmpleadosVista> {
  final List<Map<String, String>> empleados = [
    {"nombre": "Carlos Pérez", "cargo": "Cocinero", "telefono": "71234567"},
    {"nombre": "Ana López", "cargo": "Mesera", "telefono": "74589632"},
    {"nombre": "Luis Gómez", "cargo": "Repartidor", "telefono": "75678901"},
    {"nombre": "María Torres", "cargo": "Gerente", "telefono": "78901234"},
    {"nombre": "Jorge Rojas", "cargo": "Mesero", "telefono": "79876543"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gestión de empleados 👥', style: TextoStyle.contenido),
            const SizedBox(height: 20),

            // Grid de empleados (2 por fila)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: empleados.map((empleado) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.person, size: 40, color: Colors.orangeAccent),
                          Text(
                            empleado['nombre']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            empleado['cargo']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Tel: ${empleado['telefono']}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Acción editar
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Acción eliminar
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Botón para agregar nuevo empleado
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción agregar nuevo empleado
                },
                icon: const Icon(Icons.add),
                label: const Text("Agregar empleado"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresStyle.acento,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
