import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  // Datos de ejemplo para el dashboard
  final Map<String, int> estadisticas = {
    "Pedidos Realizados": 120,
    "Pedidos en Espera": 15,
    "Pedidos Cancelados": 5,
    "Total Ventas (Bs)": 4500,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard 📊', style: TextoStyle.contenido),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: estadisticas.entries.map((entry) {
                  Color cardColor;
                  IconData iconData;

                  switch (entry.key) {
                    case "Pedidos Realizados":
                      cardColor = Colors.green;
                      iconData = Icons.check_circle;
                      break;
                    case "Pedidos en Espera":
                      cardColor = Colors.orange;
                      iconData = Icons.access_time;
                      break;
                    case "Pedidos Cancelados":
                      cardColor = Colors.red;
                      iconData = Icons.cancel;
                      break;
                    case "Total Ventas (Bs)":
                      cardColor = Colors.blue;
                      iconData = Icons.attach_money;
                      break;
                    default:
                      cardColor = Colors.grey;
                      iconData = Icons.info;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(iconData, size: 40, color: cardColor),
                          const SizedBox(height: 10),
                          Text(
                            entry.key,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.value.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
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
