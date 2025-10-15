import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestión de pagina inicio ', style: TextoStyle.contenido),
    );
  }
}
