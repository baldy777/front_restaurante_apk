import 'package:app_movil/core/colores_style.dart';
import 'package:flutter/material.dart';

class PedidosDiarioVista extends StatefulWidget {
  const PedidosDiarioVista({super.key});

  @override
  State<PedidosDiarioVista> createState() =>
      _PedidosDiarioPedidosDiarioVistaState();
}

class _PedidosDiarioPedidosDiarioVistaState extends State<PedidosDiarioVista> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestión de pedidos 🛒', style: TextoStyle.contenido),
    );
  }
}
