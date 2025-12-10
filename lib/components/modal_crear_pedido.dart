import 'package:app_movil/models/pedido_model.dart';
import 'package:app_movil/models/productos.dart';
import 'package:app_movil/models/usuarios.dart';
import 'package:app_movil/services/pedidos_service.dart';
import 'package:app_movil/services/producto_service.dart';
import 'package:app_movil/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalCrearPedido extends StatefulWidget {
  final Pedido? pedidoExistente;
  final Function(Pedido) onGuardar;

  const ModalCrearPedido({
    super.key,
    this.pedidoExistente,
    required this.onGuardar,
  });

  @override
  State<ModalCrearPedido> createState() => _ModalCrearPedidoState();
}

class _ModalCrearPedidoState extends State<ModalCrearPedido> {
  final _formKey = GlobalKey<FormState>();
  final _notasController = TextEditingController();
  final _apiService = PedidosApiService();
  final _productosService = ProductoService();
  final _usuariosService = UsuarioApiGet();

  String _metodoPago = MetodoPago.efectivo;
  String _tipoEntrega = TipoEntrega.llevar;
  List<DetallePedido> _detalles = [];
  bool _isLoading = false;

  // Datos del backend
  int? _usuarioIdSeleccionado;
  List<Usuarios> _usuarios = [];
  List<Producto> _productos = [];
  bool _cargandoDatos = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _cargandoDatos = true);

    try {
      final results = await Future.wait([
        _usuariosService.obtenerUsuarios(),
        _productosService.obtenerProductosActivos(),
      ]);

      setState(() {
        _usuarios = results[0] as List<Usuarios>;
        _productos = results[1] as List<Producto>;
      });

      await _cargarUsuarioActual();

      if (widget.pedidoExistente != null) {
        _cargarDatosPedido(widget.pedidoExistente!);
      }
    } catch (e) {
      _mostrarSnackbar('Error al cargar datos: $e', Colors.red);
    } finally {
      setState(() => _cargandoDatos = false);
    }
  }

  Future<void> _cargarUsuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null && widget.pedidoExistente == null) {
      setState(() {
        _usuarioIdSeleccionado = userId;
      });
    }
  }

  void _cargarDatosPedido(Pedido pedido) {
    setState(() {
      _usuarioIdSeleccionado = pedido.usuarioId;
      _metodoPago = pedido.metodoPago;
      _tipoEntrega = pedido.tipoEntrega;
      _notasController.text = pedido.notas ?? '';
      _detalles = List.from(pedido.detalles);
    });
  }

  // Método para mostrar el QR
  void _mostrarQR() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Código QR ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 30),

                // Imagen del QR
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Image.asset(
                    'assets\images\qr.jpeg', // Ruta de tu imagen QR
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey.shade200,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2, size: 80, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Error al cargar QR',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Instrucciones
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Instrucciones de pago:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('1. Escanea el código QR con tu app de pagos'),
                      SizedBox(height: 6),
                      Text('2. Confirma el monto del pedido'),
                      SizedBox(height: 6),
                      Text('3. Completa el pago'),
                      SizedBox(height: 6),
                      Text('4. Guarda tu comprobante'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Entendido'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: _cargandoDatos
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando datos...'),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.pedidoExistente == null
                              ? '🛒 Nuevo Pedido'
                              : '✏️ Editar Pedido',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    // Contenido
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Usuario Dropdown
                            DropdownButtonFormField<int>(
                              initialValue: _usuarioIdSeleccionado,
                              decoration: const InputDecoration(
                                labelText: 'Usuario',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              items: _usuarios.map((usuario) {
                                return DropdownMenuItem<int>(
                                  value: usuario.id,
                                  child: Text(
                                    '${usuario.nombre} ${usuario.apellidoPaterno}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: _isLoading
                                  ? null
                                  : (value) {
                                      setState(
                                        () => _usuarioIdSeleccionado = value,
                                      );
                                    },
                              validator: (value) {
                                if (value == null) {
                                  return 'Seleccione un usuario';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Método de Pago con botón QR
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _metodoPago,
                                    decoration: const InputDecoration(
                                      labelText: 'Método de Pago',
                                      prefixIcon: Icon(Icons.payment),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: MetodoPago.valores.map((metodo) {
                                      return DropdownMenuItem(
                                        value: metodo,
                                        child: Text(
                                          MetodoPago.getDisplayName(metodo),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: _isLoading
                                        ? null
                                        : (value) {
                                            setState(
                                              () => _metodoPago = value!,
                                            );
                                          },
                                  ),
                                ),
                                // Botón para mostrar QR (solo si es método QR)
                                if (_metodoPago == MetodoPago.qr) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.qr_code_2,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      tooltip: 'Ver código QR',
                                      onPressed: _isLoading ? null : _mostrarQR,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Mensaje informativo cuando es QR
                            if (_metodoPago == MetodoPago.qr)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Presiona el ícono QR para ver el código de pago',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Tipo de Entrega
                            DropdownButtonFormField<String>(
                              initialValue: _tipoEntrega,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Entrega',
                                prefixIcon: Icon(Icons.local_shipping),
                                border: OutlineInputBorder(),
                              ),
                              items: TipoEntrega.valores.map((tipo) {
                                return DropdownMenuItem(
                                  value: tipo,
                                  child: Text(TipoEntrega.getDisplayName(tipo)),
                                );
                              }).toList(),
                              onChanged: _isLoading
                                  ? null
                                  : (value) {
                                      setState(() => _tipoEntrega = value!);
                                    },
                            ),
                            const SizedBox(height: 16),

                            // Notas
                            TextFormField(
                              controller: _notasController,
                              decoration: const InputDecoration(
                                labelText: 'Notas (Opcional)',
                                prefixIcon: Icon(Icons.note),
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                              enabled: !_isLoading,
                            ),
                            const SizedBox(height: 20),

                            // Detalles del Pedido
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Productos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : _agregarProducto,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Lista de productos
                            if (_detalles.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No hay productos agregados',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            else
                              ..._detalles.asMap().entries.map((entry) {
                                int index = entry.key;
                                DetallePedido detalle = entry.value;

                                String nombreProducto =
                                    'Producto ID: ${detalle.productoId}';
                                double? precioProducto;

                                try {
                                  final producto = _productos.firstWhere(
                                    (p) => p.id == detalle.productoId,
                                  );
                                  nombreProducto = producto.nombre;
                                  precioProducto = producto.precio;
                                } catch (e) {
                                  // Si no se encuentra, mantener el ID
                                }

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(
                                        Icons.inventory_2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      nombreProducto,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Cantidad: ${detalle.cantidad}'),
                                        if (precioProducto != null)
                                          Text(
                                            'Subtotal: Bs ${(precioProducto * detalle.cantidad).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                _detalles.removeAt(index);
                                              });
                                            },
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botones de acción
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _guardarPedido,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Guardar'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  void _agregarProducto() {
    int? productoSeleccionado;
    final cantidadController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            double? precioProducto;
            String? nombreProducto;

            if (productoSeleccionado != null) {
              try {
                final producto = _productos.firstWhere(
                  (p) => p.id == productoSeleccionado,
                );
                precioProducto = producto.precio;
                nombreProducto = producto.nombre;
              } catch (e) {
                // Producto no encontrado
              }
            }

            return AlertDialog(
              title: const Text('Agregar Producto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: productoSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true, // ⬅️ IMPORTANTE: Evita overflow
                    items: _productos.map((producto) {
                      return DropdownMenuItem<int>(
                        value: producto.id,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                producto.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Bs ${producto.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        productoSeleccionado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {});
                    },
                  ),
                  if (precioProducto != null &&
                      cantidadController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Bs ${(precioProducto * (int.tryParse(cantidadController.text) ?? 0)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (productoSeleccionado != null &&
                        cantidadController.text.isNotEmpty &&
                        int.tryParse(cantidadController.text) != null &&
                        int.parse(cantidadController.text) > 0) {
                      setState(() {
                        _detalles.add(
                          DetallePedido(
                            productoId: productoSeleccionado!,
                            cantidad: int.parse(cantidadController.text),
                          ),
                        );
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor complete todos los campos correctamente',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _guardarPedido() async {
    if (!_formKey.currentState!.validate()) return;

    if (_detalles.isEmpty) {
      _mostrarSnackbar('Debe agregar al menos un producto', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pedido = Pedido(
        id: widget.pedidoExistente?.id,
        usuarioId: _usuarioIdSeleccionado!,
        metodoPago: _metodoPago,
        tipoEntrega: _tipoEntrega,
        notas: _notasController.text.isEmpty ? null : _notasController.text,
        detalles: _detalles,
      );

      Map<String, dynamic> jsonResult;

      if (widget.pedidoExistente != null) {
        jsonResult = await _apiService.actualizarPedido(
          pedido.id!,
          pedido.toJson(),
        );
        _mostrarSnackbar('Pedido actualizado exitosamente', Colors.green);
      } else {
        jsonResult = await _apiService.crearPedido(pedido);
        _mostrarSnackbar('Pedido creado exitosamente', Colors.green);
      }

      final pedidoGuardado = Pedido.fromJson(jsonResult);
      widget.onGuardar(pedidoGuardado);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _mostrarSnackbar('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarSnackbar(String mensaje, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }
}
