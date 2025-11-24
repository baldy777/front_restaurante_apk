import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/pages/main_page.dart';
import 'package:app_movil/pages/productos/menu.dart';
import 'package:app_movil/pages/productos/pedidos.dart';
import 'package:app_movil/pages/usuarios/perfil.dart';
import 'package:app_movil/pages/usuarios/tabla_empleados.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  // Verifica si el usuario está logueado
  void _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      // Redirige al login si no hay token
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Cerrar sesión
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
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
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Empleados'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
