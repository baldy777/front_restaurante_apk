import 'dart:convert';

import 'package:app_movil/models/usuarios.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UsuarioApiGet {
  final String apiUrl =
      'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/usuarios';

  // Obtener todos los usuarios (existente)
  Future<List<Usuarios>> obtenerUsuarios() async {
    print("Llamado a la API para obtener usuarios");
    final response = await http.get(Uri.parse(apiUrl));

    print("Respuesta de la API: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Datos decodificados: $data");
      return data.map((json) => Usuarios.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los usuarios: ${response.statusCode}');
    }
  }

  // Obtener un usuario específico por ID (nuevo)
  Future<Usuarios> obtenerUsuario(int id) async {
    final url = Uri.parse('$apiUrl/$id');
    print("Llamado a la API para obtener usuario con ID: $id");

    final response = await http.get(url);

    print("Respuesta de la API: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuarios.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al cargar el usuario: ${response.statusCode}');
    }
  }

  // Actualizar un usuario (PUT completo, nuevo)
  Future<Usuarios> actualizarUsuario(
    int id,
    Map<String, dynamic> usuarioData,
  ) async {
    final url = Uri.parse('$apiUrl/$id');
    print("Llamado a la API para actualizar usuario con ID: $id");

    final response = await http.put(
      url,
      body: jsonEncode(usuarioData),
      headers: {"Content-Type": "application/json"},
    );

    print("Respuesta de la API: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuarios.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al actualizar el usuario: ${response.statusCode}');
    }
  }

  // Eliminar un usuario (DELETE, nuevo - asumiendo que existe en el backend)
  Future<void> eliminarUsuario(int id) async {
    final url = Uri.parse('$apiUrl/$id');
    print("Llamado a la API para eliminar usuario con ID: $id");

    final response = await http.delete(url);

    print("Respuesta de la API: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      // 204 No Content es común para DELETE exitoso
      print("Usuario eliminado correctamente");
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al eliminar el usuario: ${response.statusCode}');
    }
  }
}

class UsuarioApiPost {
  Future<dynamic> crearUsuario({
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String correo,
    required String contrasena,
    required String telefono,
    required int rolId,
  }) async {
    final url = Uri.parse(
      "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/usuarios",
    );

    final body = {
      "nombre": nombre,
      "apellidoPaterno": apellidoPaterno,
      "apellidoMaterno": apellidoMaterno,
      "correo": correo,
      "contrasena": contrasena,
      "telefono": telefono,
      "rolesIds": [rolId], // <=== IMPORTANTE
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
