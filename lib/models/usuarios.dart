class Usuarios {
  final int id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String telefono;
  final String rol;

  Usuarios({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.telefono,
    required this.rol,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      rol:
          json['roles'] != null &&
              json['roles'] is List &&
              json['roles'].isNotEmpty
          ? json['roles'][0]['rol']['nombre'] ?? ''
          : '',
    );
  }
}
