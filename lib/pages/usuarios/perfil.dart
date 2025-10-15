import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class UserPerfilVista extends StatefulWidget {
  const UserPerfilVista({super.key});

  @override
  State<UserPerfilVista> createState() => _UserPerfilVistaState();
}

class _UserPerfilVistaState extends State<UserPerfilVista> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestión del perfil 👤', style: TextoStyle.contenido),
    );
  }
}
