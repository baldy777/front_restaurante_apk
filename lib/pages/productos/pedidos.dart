import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class PedidosDiarioVista extends StatefulWidget {
  const PedidosDiarioVista({super.key});

  @override
  State<PedidosDiarioVista> createState() =>
      _PedidosDiarioPedidosDiarioVistaState();
}

class _PedidosDiarioPedidosDiarioVistaState
    extends State<PedidosDiarioVista> {
  // Ejemplo de pedidos diarios
  final List<Map<String, dynamic>> pedidos = [
    {"cliente": "Carlos Pérez", "total": 55.0, "estado": "Enviado"},
    {"cliente": "Ana Gómez", "total": 30.0, "estado": "Pendiente"},
    {"cliente": "Luis Martínez", "total": 45.0, "estado": "Enviado"},
    {"cliente": "María López", "total": 60.0, "estado": "Pendiente"},
    {"cliente": "Jorge Rojas", "total": 25.0, "estado": "Entregado"},
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
            const Text('Gestión de pedidos 🛒', style: TextoStyle.contenido),
            const SizedBox(height: 20),

            // Grid de pedidos (2 por fila)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2, // Ajusta altura vs ancho
                children: pedidos.map((pedido) {
                  Color estadoColor;
                  switch (pedido['estado']) {
                    case "Pendiente":
                      estadoColor = Colors.orange;
                      break;
                    case "Enviado":
                      estadoColor = Colors.blue;
                      break;
                    case "Entregado":
                      estadoColor = Colors.green;
                      break;
                    default:
                      estadoColor = Colors.grey;
                  }

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
                          const Icon(Icons.shopping_cart,
                              size: 40, color: Colors.orangeAccent),
                          Text(
                            pedido['cliente'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Total: Bs ${pedido['total']}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: estadoColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              pedido['estado'],
                              style: TextStyle(
                                color: estadoColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
