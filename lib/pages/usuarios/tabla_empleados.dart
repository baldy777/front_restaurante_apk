import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class EmpleadosVista extends StatefulWidget {
  const EmpleadosVista({super.key});

  @override
  State<EmpleadosVista> createState() => _EmpleadosVistaState();
}

class _EmpleadosVistaState extends State<EmpleadosVista> {
  @override
  Widget build(BuildContext context) {
return const Center(
      child: Text(
        'Gestión de empleados 👥',
        style: TextoStyle.contenido,
      ),
    );  }
}
