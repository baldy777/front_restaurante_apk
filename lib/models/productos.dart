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
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] ?? 0).toDouble(),
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
      id: json['id'],
      nombre: json['nombre'],
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
      id: json['id'],
      nombre: json['nombre'],
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
