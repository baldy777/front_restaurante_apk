// lib/models/pedido_model.dart

class Pedido {
  final int? id;
  final String? numeroPedido;
  final int usuarioId;
  final String metodoPago; // EFECTIVO o QR
  final String tipoEntrega; // LLEVAR o PARA_AQUI
  final String estado; // PENDIENTE, ACEPTADO, etc.
  final double? total;
  final double? subtotal;
  final String? notas;
  final DateTime? fechaPedido;
  final List<DetallePedido> detalles;
  final String? clienteNombre;

  Pedido({
    this.id,
    this.numeroPedido,
    required this.usuarioId,
    required this.metodoPago,
    required this.tipoEntrega,
    this.estado = 'PENDIENTE',
    this.total,
    this.subtotal,
    this.notas,
    this.fechaPedido,
    required this.detalles,
    this.clienteNombre,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    // Manejar la respuesta del backend que viene envuelta en "datos"
    final data = json['datos'] ?? json;

    return Pedido(
      id: data['id'],
      numeroPedido: data['numeroPedido'],
      usuarioId: data['cliente']?['id'] ?? data['usuarioId'],
      metodoPago: data['metodoPago'] ?? 'EFECTIVO',
      tipoEntrega: data['tipoEntrega'] ?? 'LLEVAR',
      estado: data['estado'] ?? 'PENDIENTE',
      total: _parseDecimal(data['total']),
      subtotal: _parseDecimal(data['subtotal']),
      notas: data['notas'],
      fechaPedido: data['fechaPedido'] != null
          ? DateTime.parse(data['fechaPedido'])
          : null,
      detalles:
          (data['detalles'] as List?)
              ?.map((d) => DetallePedido.fromJson(d))
              .toList() ??
          [],
      clienteNombre: data['cliente']?['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'metodoPago': metodoPago,
      'tipoEntrega': tipoEntrega,
      'notas': notas,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }

  static double? _parseDecimal(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class DetallePedido {
  final int? id;
  final int productoId;
  final int cantidad;
  final double? precioUnitario;
  final double? subtotal;
  final String? productoNombre;

  DetallePedido({
    this.id,
    required this.productoId,
    required this.cantidad,
    this.precioUnitario,
    this.subtotal,
    this.productoNombre,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'],
      productoId: json['producto']?['id'] ?? json['productoId'],
      cantidad: json['cantidad'],
      precioUnitario: Pedido._parseDecimal(json['precioUnitario']),
      subtotal: Pedido._parseDecimal(json['subtotal']),
      productoNombre: json['producto']?['nombre'] ?? json['productoNombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'productoId': productoId, 'cantidad': cantidad};
  }
}

// Enums para los valores válidos del backend
class MetodoPago {
  static const String efectivo = 'EFECTIVO';
  static const String qr = 'QR';

  static List<String> get valores => [efectivo, qr];

  static String getDisplayName(String value) {
    switch (value) {
      case efectivo:
        return 'Efectivo';
      case qr:
        return 'QR';
      default:
        return value;
    }
  }
}

class TipoEntrega {
  static const String llevar = 'LLEVAR';
  static const String paraAqui = 'PARA_AQUI';

  static List<String> get valores => [llevar, paraAqui];

  static String getDisplayName(String value) {
    switch (value) {
      case llevar:
        return 'Para Llevar';
      case paraAqui:
        return 'Para Aquí';
      default:
        return value;
    }
  }
}

class EstadoPedido {
  static const String pendiente = 'PENDIENTE';
  static const String aceptado = 'ACEPTADO';
  static const String enPreparacion = 'EN_PREPARACION';
  static const String listo = 'LISTO';
  static const String completado = 'COMPLETADO';
  static const String cancelado = 'CANCELADO';

  static List<String> get valores => [
    pendiente,
    aceptado,
    enPreparacion,
    listo,
    completado,
    cancelado,
  ];

  static String getDisplayName(String value) {
    switch (value) {
      case pendiente:
        return 'Pendiente';
      case aceptado:
        return 'Aceptado';
      case enPreparacion:
        return 'En Preparación';
      case listo:
        return 'Listo';
      case completado:
        return 'Completado';
      case cancelado:
        return 'Cancelado';
      default:
        return value;
    }
  }

  static String getEmoji(String value) {
    switch (value) {
      case pendiente:
        return '⏳';
      case aceptado:
        return '✅';
      case enPreparacion:
        return '👨‍🍳';
      case listo:
        return '🎉';
      case completado:
        return '✔️';
      case cancelado:
        return '❌';
      default:
        return '📦';
    }
  }
}
