import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class MenuVista extends StatefulWidget {
  const MenuVista({super.key});

  @override
  State<MenuVista> createState() => _MenuVistaState();
}

class _MenuVistaState extends State<MenuVista> {
  // Lista de platillos del menú (ejemplo estático)
  final List<Map<String, dynamic>> menu = [
    {"nombre": "Pique Macho", "precio": 35.0},
    {"nombre": "Sopa de Mani", "precio": 18.0},
    {"nombre": "Chicha Morada", "precio": 8.0},
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
            const Text('Gestión del menú 🍽️', style: TextoStyle.contenido),
            const SizedBox(height: 20),

            // Tabla de menú
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    ColoresStyle.encabezado,
                  ),
                  dataRowColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        // ignore: deprecated_member_use
                        ? ColoresStyle.acento.withOpacity(0.2)
                        : ColoresStyle.fondo,
                  ),
                  headingTextStyle: TextoStyle.titulo,
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Precio (Bs)')),
                    DataColumn(label: Text('Accion')),
                  ],
                  rows: menu.map((plato) {
                    return DataRow(
                      cells: [
                        DataCell(Text(plato['nombre'])),
                        DataCell(Text(plato['precio'].toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // abre modal para editar plato
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Boton para agregar nuevo plato
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Agregar nuevo plato, crear modal
                },
                icon: const Icon(Icons.add),
                label: const Text("Agregar plato"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresStyle.acento,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
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
