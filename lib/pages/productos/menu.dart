import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class MenuVista extends StatefulWidget {
  const MenuVista({super.key});

  @override
  State<MenuVista> createState() => _MenuVistaState();
}

class _MenuVistaState extends State<MenuVista> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestión del menu 🍽️', style: TextoStyle.contenido),
    );
  }
}
