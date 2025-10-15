import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/pages/main_page.dart';
import 'package:app_movil/pages/productos/menu.dart';
import 'package:app_movil/pages/productos/pedidos.dart';
import 'package:app_movil/pages/usuarios/perfil.dart';
import 'package:app_movil/pages/usuarios/tabla_empleados.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MenuPrincipal(),
    PedidosDiarioVista(),
    MenuVista(),
    EmpleadosVista(),
    UserPerfilVista(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      appBar: AppBar(
        backgroundColor: ColoresStyle.encabezado,
        title: const Text(
          "Restaurante App",
          style: TextStyle(
            fontFamily: "arial",
            fontSize: 22,
            color: Colors.white,
          ),
        ),

        centerTitle: true,
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: ColoresStyle.acento,
        selectedItemColor: ColoresStyle.encabezado,
        unselectedItemColor: ColoresStyle.detalles,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Empleados'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
