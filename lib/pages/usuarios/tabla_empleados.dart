import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class EmpleadosVista extends StatefulWidget {
  const EmpleadosVista({super.key});

  @override
  State<EmpleadosVista> createState() => _EmpleadosVistaState();
}

class _EmpleadosVistaState extends State<EmpleadosVista> {
  // Lista temporal de empleados (puedes reemplazarla luego con datos de tu backend)
  final List<Map<String, String>> empleados = [
    {"nombre": "Carlos Pérez", "cargo": "Cocinero", "telefono": "71234567"},
    {"nombre": "Ana López", "cargo": "Mesera", "telefono": "74589632"},
    {"nombre": "Luis Gómez", "cargo": "Repartidor", "telefono": "75678901"},
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
            const Text(
              'Gestión de empleados 👥',
              style: TextoStyle.contenido,
            ),
            const SizedBox(height: 20),

            // Tabla
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(ColoresStyle.encabezado),
                  dataRowColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        // ignore: deprecated_member_use
                        ? ColoresStyle.acento.withOpacity(0.2)
                        : ColoresStyle.fondo,
                  ),
                  headingTextStyle: TextoStyle.titulo,
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cargo')),
                    DataColumn(label: Text('Teléfono')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: empleados.map((empleado) {
                    return DataRow(cells: [
                      DataCell(Text(empleado['nombre']!)),
                      DataCell(Text(empleado['cargo']!)),
                      DataCell(Text(empleado['telefono']!)),
                      DataCell(Row(
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
                      )),
                    ]);
                  }).toList(),
                ),
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
