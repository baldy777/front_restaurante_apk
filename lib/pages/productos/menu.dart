import 'package:app_movil/components/producto_modal.dart';
import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/models/productos.dart';
import 'package:app_movil/services/producto_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Agregado para SharedPreferences

class MenuVista extends StatefulWidget {
  const MenuVista({super.key});

  @override
  State<MenuVista> createState() => _MenuVistaState();
}

class _MenuVistaState extends State<MenuVista> {
  final ProductoService productoService = ProductoService();
  List<Producto> productos = [];
  bool isLoading = true;
  String? errorMessage;

  // Variables para rol de usuario
  String? _rolUsuario;
  bool _esAdmin = false;
  bool _cargandoRol = true;

  @override
  void initState() {
    super.initState();
    _cargarRolYProductos();
  }

  // Cargar el rol del usuario desde SharedPreferences y luego los productos
  Future<void> _cargarRolYProductos() async {
    setState(() => _cargandoRol = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final rol =
          prefs.getString('userRol') ??
          'Usuario'; // Asumiendo que el rol se guarda como 'userRol'

      setState(() {
        _rolUsuario = rol;
        _esAdmin =
            rol.toLowerCase() ==
            'admin'; // Asumiendo que 'admin' es el rol de administrador
        _cargandoRol = false;
      });

      await _cargarProductos();
    } catch (e) {
      setState(() => _cargandoRol = false);
      _mostrarError('Error al cargar rol de usuario: $e');
    }
  }

  Future<void> _cargarProductos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('🔄 Iniciando carga de productos...');
      final prods = await productoService.obtenerProductos();
      print('✅ Productos recibidos: ${prods.length}');

      // Imprimir cada producto para debug
      for (var prod in prods) {
        print('📦 Producto: ${prod.nombre} - Precio: ${prod.precio}');
      }

      setState(() {
        productos = prods;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error al cargar productos: $e');
      setState(() {
        errorMessage = 'Error al cargar productos: $e';
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _eliminarProducto(Producto producto) async {
    if (!_esAdmin) return; // Solo admin puede eliminar

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar plato'),
        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final eliminado = await productoService.eliminarProducto(producto.id);
      if (eliminado) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Plato eliminado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarProductos();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al eliminar el plato'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoRol) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: ColoresStyle.fondo,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gestión del menú 🍽️', style: TextoStyle.contenido),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _cargarProductos,
                  tooltip: 'Recargar productos',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mostrar estado de carga o error
            if (isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Cargando productos...'),
                    ],
                  ),
                ),
              )
            else if (errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error al cargar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _cargarProductos,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresStyle.acento,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (productos.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay productos registrados',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Lista de tarjetas con Wrap
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _cargarProductos,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: productos.map((producto) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 44) / 2,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu,
                                    size: 40,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    producto.nombre,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (producto.descripcion != null &&
                                      producto.descripcion!.isNotEmpty)
                                    Text(
                                      producto.descripcion!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Bs ${producto.precio.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (producto.disponibilidad != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "Stock: ${producto.disponibilidad}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  // Mostrar botones solo si es admin
                                  if (_esAdmin)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ProductoModal(
                                                    producto: producto,
                                                    onGuardado:
                                                        _cargarProductos,
                                                  ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              _eliminarProducto(producto),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Mostrar botón de agregar solo si es admin
            if (_esAdmin)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProductoModal(onGuardado: _cargarProductos),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar plato"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresStyle.acento,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
