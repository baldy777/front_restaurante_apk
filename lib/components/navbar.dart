import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/pages/main_page.dart';
import 'package:app_movil/pages/productos/menu.dart';
import 'package:app_movil/pages/productos/pedidos.dart';
import 'package:app_movil/pages/usuarios/perfil.dart';
import 'package:app_movil/pages/usuarios/tabla_empleados.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  String userRole = "";

  // Listas de páginas por rol
  final List<Widget> _adminPages = const [
    MenuPrincipal(),
    PedidosDiarioVista(),
    MenuVista(),
    EmpleadosVista(),
    UserPerfilVista(),
  ];

  final List<Widget> _userPages = const [
    PedidosDiarioVista(),
    MenuVista(),
    UserPerfilVista(),
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    print("DEBUG token en navbar: $token");

    final rol = prefs.getString('userRol');
    print("DEBUG role en navbar: $rol");

    if (token == null) {
      print("DEBUG: no hay token → volver a login");
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    userRole = rol ?? "";
    print("DEBUG userRole asignado: $userRole");

    setState(() {});
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBar _adminNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: ColoresStyle.acento,
      selectedItemColor: ColoresStyle.encabezado,
      unselectedItemColor: ColoresStyle.detalles,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pedidos'),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Empleados'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  BottomNavigationBar _userNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: ColoresStyle.acento,
      selectedItemColor: ColoresStyle.encabezado,
      unselectedItemColor: ColoresStyle.detalles,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pedidos'),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userRole.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = userRole == "Administrador" ? _adminPages : _userPages;
    final navBar = userRole == "Administrador" ? _adminNavBar() : _userNavBar();
    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

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
      body: pages[safeIndex],
      bottomNavigationBar: navBar,
    );
  }
}
