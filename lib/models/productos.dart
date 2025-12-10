class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int? disponibilidad;
  final String? imagen;
  final bool activo;
  final int subcategoriaId;
  final SubCategoria? subcategoria;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.disponibilidad,
    this.imagen,
    this.activo = true,
    required this.subcategoriaId,
    this.subcategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      // ⬇️ CORRECCIÓN: Maneja string o number del decimal de PostgreSQL
      precio: _parsePrecio(json['precio']),
      disponibilidad: json['disponibilidad'],
      imagen: json['imagen'],
      activo: json['activo'] ?? true,
      subcategoriaId: json['subcategoria'] is int
          ? json['subcategoria']
          : json['subcategoria']?['id'] ?? 0,
      subcategoria: json['subcategoria'] != null && json['subcategoria'] is Map
          ? SubCategoria.fromJson(json['subcategoria'])
          : null,
    );
  }

  // Método helper para parsear el precio
  static double _parsePrecio(dynamic precio) {
    if (precio == null) return 0.0;
    if (precio is double) return precio;
    if (precio is int) return precio.toDouble();
    if (precio is String) {
      return double.tryParse(precio) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'disponibilidad': disponibilidad,
      'imagen': imagen,
      'subcategoria': subcategoriaId,
    };
  }
}

class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.activo = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'descripcion': descripcion};
  }
}

class SubCategoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;
  final int categoriaId;
  final Categoria? categoria;

  SubCategoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.activo = true,
    required this.categoriaId,
    this.categoria,
  });

  factory SubCategoria.fromJson(Map<String, dynamic> json) {
    return SubCategoria(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      activo: json['activo'] ?? true,
      categoriaId: json['categoria'] is int
          ? json['categoria']
          : json['categoria']?['id'] ?? 0,
      categoria: json['categoria'] != null && json['categoria'] is Map
          ? Categoria.fromJson(json['categoria'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoriaId,
    };
  }
}
