import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class MenuVista extends StatefulWidget {
  const MenuVista({super.key});

  @override
  State<MenuVista> createState() => _MenuVistaState();
}

class _MenuVistaState extends State<MenuVista> {
  final List<Map<String, dynamic>> menu = [
    {"nombre": "Pique Macho", "precio": 35.0},
    {"nombre": "Sopa de Mani", "precio": 18.0},
    {"nombre": "Chicha Morada", "precio": 8.0},
    {"nombre": "Silpancho", "precio": 30.0},
    {"nombre": "Api con pastel", "precio": 10.0},
    {"nombre": "Ensalada tropical", "precio": 20.0},
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

            // Grid de tarjetas (2 por fila)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1, // 1 = cuadrado
                children: menu.map((plato) {
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
                          const Icon(Icons.restaurant_menu,
                              size: 40, color: Colors.orangeAccent),
                          Text(
                            plato['nombre'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Bs ${plato['precio']}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // abrir modal para editar plato
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Agregar nuevo plato
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
