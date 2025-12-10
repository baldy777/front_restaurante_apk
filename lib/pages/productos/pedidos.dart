import 'package:app_movil/components/modal_crear_pedido.dart';
import 'package:app_movil/components/modal_detalle_pedido.dart';
import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/services/pedidos_service.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/models/pedido_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosDiarioVista extends StatefulWidget {
  const PedidosDiarioVista({super.key});

  @override
  State<PedidosDiarioVista> createState() => _PedidosDiarioVistaState();
}

class _PedidosDiarioVistaState extends State<PedidosDiarioVista> {
  // Servicio API
  late PedidosApiService _apiService;

  // Lista de pedidos
  List<Pedido> pedidos = [];
  bool _isLoading = false;
  String? _filtroEstado;

  // Rol del usuario actual
  String? _rolUsuario;
  bool _esCocinero = false;
  bool _cargandoRol = true;

  @override
  void initState() {
    super.initState();
    _apiService = PedidosApiService();
    _cargarRolYPedidos();
  }

  // Cargar el rol del usuario desde SharedPreferences
  Future<void> _cargarRolYPedidos() async {
    setState(() => _cargandoRol = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final rol = prefs.getString('userRol') ?? 'Usuario';

      setState(() {
        _rolUsuario = rol;
        _esCocinero = rol.toLowerCase() == 'cocinero';
        _cargandoRol = false;
      });

      await _cargarPedidos();
    } catch (e) {
      setState(() => _cargandoRol = false);
      _mostrarError('Error al cargar rol de usuario');
    }
  }

  // Carga los pedidos desde la API
  Future<void> _cargarPedidos() async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.obtenerPedidos(
        estado: _filtroEstado,
        pagina: 1,
        limite: 50,
      );

      setState(() {
        pedidos = (response['datos'] as List)
            .map((json) => Pedido.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarError('Error al cargar pedidos: $e');
    }
  }

  // Muestra el modal para crear un nuevo pedido (solo admin y mesero)
  void _mostrarModalCrear() {
    if (_esCocinero) return;

    showDialog(
      context: context,
      builder: (context) => ModalCrearPedido(
        onGuardar: (pedido) async {
          try {
            await _apiService.crearPedido(pedido);
            _mostrarMensaje('Pedido creado exitosamente', Colors.green);
            _cargarPedidos();
          } catch (e) {
            _mostrarError('Error al crear pedido: $e');
          }
        },
      ),
    );
  }

  // Muestra el modal para ver detalles
  void _mostrarModalDetalle(Pedido pedido) {
    if (_esCocinero) {
      // Modal para cocinero (solo completar)
      showDialog(
        context: context,
        builder: (context) => ModalDetallePedido(
          pedido: pedido,
          onCompletar: () async {
            Navigator.pop(context);
            final confirmar = await _mostrarConfirmacion(
              '¿Marcar como completado?',
              '¿Confirmas que este pedido está completado?',
            );

            if (confirmar) {
              await _completarPedido(pedido);
            }
          },
        ),
      );
    } else {
      // Modal para admin/mesero (editar y cancelar)
      showDialog(
        context: context,
        builder: (context) => ModalDetallePedido(
          pedido: pedido,
          onEditar: () {
            Navigator.pop(context);
            _mostrarModalEditar(pedido);
          },
          onCancelar: () async {
            Navigator.pop(context);
            final confirmar = await _mostrarConfirmacion(
              '¿Cancelar pedido?',
              '¿Estás seguro de cancelar este pedido?',
            );

            if (confirmar) {
              try {
                await _apiService.cancelarPedido(pedido.id!);
                _mostrarMensaje('Pedido cancelado', Colors.orange);
                _cargarPedidos();
              } catch (e) {
                _mostrarError('Error al cancelar: $e');
              }
            }
          },
        ),
      );
    }
  }

  // Muestra el modal para editar (solo admin y mesero)
  void _mostrarModalEditar(Pedido pedido) {
    if (_esCocinero) return;

    showDialog(
      context: context,
      builder: (context) => ModalCrearPedido(
        pedidoExistente: pedido,
        onGuardar: (pedidoActualizado) async {
          try {
            await _apiService.actualizarPedido(
              pedido.id!,
              pedidoActualizado.toJson(),
            );
            _mostrarMensaje('Pedido actualizado', Colors.blue);
            _cargarPedidos();
          } catch (e) {
            _mostrarError('Error al actualizar: $e');
          }
        },
      ),
    );
  }

  // Marca un pedido como completado (para cocinero)
  Future<void> _completarPedido(Pedido pedido) async {
    try {
      final pedidoActualizado = Pedido(
        id: pedido.id,
        usuarioId: pedido.usuarioId,
        metodoPago: pedido.metodoPago,
        tipoEntrega: pedido.tipoEntrega,
        estado: EstadoPedido.completado,
        notas: pedido.notas,
        detalles: pedido.detalles,
      );

      await _apiService.actualizarPedido(
        pedido.id!,
        pedidoActualizado.toJson(),
      );

      _mostrarMensaje('Pedido completado exitosamente ✅', Colors.green);
      _cargarPedidos();
    } catch (e) {
      _mostrarError('Error al completar pedido: $e');
    }
  }

  // Muestra diálogo de confirmación
  Future<bool> _mostrarConfirmacion(String titulo, String mensaje) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.help_outline, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(child: Text(titulo)),
              ],
            ),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Muestra mensaje de éxito
  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Muestra mensaje de error
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
            // Header con título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _esCocinero
                        ? Colors.orange.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _esCocinero ? Icons.restaurant_menu : Icons.shopping_cart,
                    color: _esCocinero ? Colors.orange : Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _esCocinero ? 'Pedidos del Día' : 'Gestión de Pedidos',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _esCocinero ? 'Vista de Cocina' : 'Panel de Control',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón de refrescar
                IconButton(
                  onPressed: _cargarPedidos,
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue,
                  ),
                  tooltip: 'Actualizar pedidos',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filtro por estado
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FiltroChip(
                    label: 'Todos',
                    icon: Icons.list_alt,
                    selected: _filtroEstado == null,
                    onTap: () {
                      setState(() => _filtroEstado = null);
                      _cargarPedidos();
                    },
                  ),
                  _FiltroChip(
                    label: 'Pendientes',
                    icon: Icons.hourglass_empty,
                    selected: _filtroEstado == EstadoPedido.pendiente,
                    color: Colors.orange,
                    onTap: () {
                      setState(() => _filtroEstado = EstadoPedido.pendiente);
                      _cargarPedidos();
                    },
                  ),
                  _FiltroChip(
                    label: 'En Preparación',
                    icon: Icons.restaurant,
                    selected: _filtroEstado == EstadoPedido.enPreparacion,
                    color: Colors.blue,
                    onTap: () {
                      setState(
                        () => _filtroEstado = EstadoPedido.enPreparacion,
                      );
                      _cargarPedidos();
                    },
                  ),
                  _FiltroChip(
                    label: 'Listos',
                    icon: Icons.check_circle,
                    selected: _filtroEstado == EstadoPedido.listo,
                    color: Colors.purple,
                    onTap: () {
                      setState(() => _filtroEstado = EstadoPedido.listo);
                      _cargarPedidos();
                    },
                  ),
                  _FiltroChip(
                    label: 'Completados',
                    icon: Icons.done_all,
                    selected: _filtroEstado == EstadoPedido.completado,
                    color: Colors.green,
                    onTap: () {
                      setState(() => _filtroEstado = EstadoPedido.completado);
                      _cargarPedidos();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contador de pedidos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Total: ${pedidos.length} ${pedidos.length == 1 ? 'pedido' : 'pedidos'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid de pedidos
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando pedidos...'),
                        ],
                      ),
                    )
                  : pedidos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay pedidos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Los pedidos aparecerán aquí',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarPedidos,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: pedidos.length,
                        itemBuilder: (context, index) {
                          final pedido = pedidos[index];
                          return _PedidoCard(
                            pedido: pedido,
                            onTap: () => _mostrarModalDetalle(pedido),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // Botón flotante solo para admin y mesero
      floatingActionButton: !_esCocinero
          ? FloatingActionButton(
              onPressed: _mostrarModalCrear,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, size: 32),
            )
          : null,
    );
  }
}

// Widget para las cards de pedidos
class _PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTap;

  const _PedidoCard({required this.pedido, required this.onTap});

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case "PENDIENTE":
        return Colors.orange;
      case "ACEPTADO":
        return Colors.blue;
      case "EN_PREPARACION":
        return Colors.blue;
      case "LISTO":
        return Colors.purple;
      case "COMPLETADO":
        return Colors.green;
      case "CANCELADO":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case "PENDIENTE":
        return Icons.hourglass_empty;
      case "ACEPTADO":
        return Icons.check_circle_outline;
      case "EN_PREPARACION":
        return Icons.restaurant;
      case "LISTO":
        return Icons.done;
      case "COMPLETADO":
        return Icons.done_all;
      case "CANCELADO":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadoColor = _getEstadoColor(pedido.estado);
    final estadoIcon = _getEstadoIcon(pedido.estado);
    final cantidadProductos = pedido.detalles.fold<int>(
      0,
      (sum, d) => sum + d.cantidad,
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: estadoColor.withOpacity(0.3), width: 2),
        ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, estadoColor.withOpacity(0.05)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con número de pedido
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Pedido #${pedido.numeroPedido ?? pedido.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(estadoIcon, size: 18, color: estadoColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Información del cliente
                if (pedido.clienteNombre != null) ...[
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pedido.clienteNombre!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],

                // Cantidad de productos
                Row(
                  children: [
                    Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '$cantidadProductos ${cantidadProductos == 1 ? 'producto' : 'productos'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Tipo de entrega
                Row(
                  children: [
                    Icon(
                      pedido.tipoEntrega == TipoEntrega.llevar
                          ? Icons.takeout_dining
                          : Icons.restaurant,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TipoEntrega.getDisplayName(pedido.tipoEntrega),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const Spacer(),

                // Total y estado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pedido.total != null)
                      Text(
                        'Bs ${pedido.total!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: estadoColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        EstadoPedido.getDisplayName(pedido.estado),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: estadoColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para los chips de filtro
class _FiltroChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Colors.blue;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? chipColor : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: chipColor.withOpacity(0.2),
        checkmarkColor: chipColor,
        labelStyle: TextStyle(
          color: selected ? chipColor : Colors.grey[700],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(
          color: selected ? chipColor : Colors.grey[300]!,
          width: selected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
