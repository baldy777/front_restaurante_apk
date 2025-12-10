import 'package:app_movil/models/pedido_model.dart';
import 'package:flutter/material.dart';

class ModalDetallePedido extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? onCompletar;
  final VoidCallback? onEditar;
  final VoidCallback? onCancelar;

  const ModalDetallePedido({
    super.key,
    required this.pedido,
    this.onCompletar,
    this.onEditar,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    Color estadoColor = _getEstadoColor(pedido.estado);
    IconData estadoIcon = _getEstadoIcon(pedido.estado);
    bool puedeCompletar = _puedeCompletarPedido(pedido.estado);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 650),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado destacado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: estadoColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(estadoIcon, color: estadoColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalle del Pedido',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pedido #${pedido.numeroPedido ?? pedido.id}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 30),

            // Badge de estado grande
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: estadoColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: estadoColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(estadoIcon, color: estadoColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    EstadoPedido.getDisplayName(pedido.estado),
                    style: TextStyle(
                      color: estadoColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contenido scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información general
                    _SeccionTitulo(titulo: 'Información General'),
                    const SizedBox(height: 12),

                    if (pedido.clienteNombre != null)
                      _InfoCard(
                        icon: Icons.person,
                        label: 'Cliente',
                        value: pedido.clienteNombre!,
                        color: Colors.blue,
                      ),

                    _InfoCard(
                      icon: pedido.tipoEntrega == TipoEntrega.llevar
                          ? Icons.takeout_dining
                          : Icons.restaurant,
                      label: 'Tipo de Entrega',
                      value: TipoEntrega.getDisplayName(pedido.tipoEntrega),
                      color: Colors.orange,
                    ),

                    _InfoCard(
                      icon: Icons.payment,
                      label: 'Método de Pago',
                      value: MetodoPago.getDisplayName(pedido.metodoPago),
                      color: Colors.purple,
                    ),

                    if (pedido.fechaPedido != null)
                      _InfoCard(
                        icon: Icons.access_time,
                        label: 'Hora del Pedido',
                        value:
                            '${_formatearFecha(pedido.fechaPedido!)} - ${_formatearHora(pedido.fechaPedido!)}',
                        color: Colors.teal,
                      ),

                    if (pedido.notas != null && pedido.notas!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.note,
                              color: Colors.amber.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notas especiales:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pedido.notas!,
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Lista de productos
                    _SeccionTitulo(
                      titulo: 'Productos (${pedido.detalles.length})',
                    ),
                    const SizedBox(height: 12),

                    ...pedido.detalles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final detalle = entry.value;
                      return _ProductoCard(detalle: detalle, numero: index + 1);
                    }),

                    const SizedBox(height: 16),

                    // Resumen del total
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade50, Colors.green.shade100],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total del Pedido:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Bs ${pedido.total?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botones de acción según los callbacks disponibles
            if (onCompletar != null && puedeCompletar) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCompletar,
                  icon: const Icon(Icons.check_circle, size: 24),
                  label: const Text(
                    'Marcar como Completado',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ] else if (onEditar != null || onCancelar != null) ...[
              Row(
                children: [
                  if (onEditar != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onEditar,
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  if (onEditar != null && onCancelar != null)
                    const SizedBox(width: 12),
                  if (onCancelar != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCancelar,
                        icon: const Icon(Icons.cancel, size: 20),
                        label: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ] else if (!puedeCompletar) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Este pedido ya ha sido procesado',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _puedeCompletarPedido(String estado) {
    return estado != EstadoPedido.completado &&
        estado != EstadoPedido.cancelado;
  }

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

  String _formatearFecha(DateTime fecha) {
    final dias = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${dias[fecha.weekday % 7]} ${fecha.day} ${meses[fecha.month - 1]}';
  }

  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }
}

// Widget para títulos de sección
class _SeccionTitulo extends StatelessWidget {
  final String titulo;

  const _SeccionTitulo({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Widget para información en cards
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para cada producto
class _ProductoCard extends StatelessWidget {
  final DetallePedido detalle;
  final int numero;

  const _ProductoCard({required this.detalle, required this.numero});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Número del producto
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$numero',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detalle.productoNombre ??
                      'Producto ID: ${detalle.productoId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'x${detalle.cantidad}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (detalle.precioUnitario != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Bs ${detalle.precioUnitario!.toStringAsFixed(2)} c/u',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Subtotal
          if (detalle.subtotal != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Bs ${detalle.subtotal!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
