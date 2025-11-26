import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/auth/login";

  Future<Map<String, dynamic>?> login(String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo, "contrasena": contrasena}),
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        // Guardar los datos del usuario en SharedPreferences
        await _guardarDatosUsuario(data);

        return data;
      }

      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  Future<void> _guardarDatosUsuario(Map<String, dynamic> respuesta) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar token
      if (respuesta['token'] != null) {
        await prefs.setString('token', respuesta['token']);
        print('✅ Token guardado: ${respuesta['token']}');
      }

      // Guardar datos del usuario
      if (respuesta['usuario'] != null) {
        final usuario = respuesta['usuario'];

        if (usuario['id'] != null) {
          await prefs.setInt('userId', usuario['id']);
          print('✅ UserId guardado: ${usuario['id']}');
        }

        if (usuario['nombre'] != null) {
          await prefs.setString('userNombre', usuario['nombre']);
          print('✅ UserNombre guardado: ${usuario['nombre']}');
        }

        if (usuario['correo'] != null) {
          await prefs.setString('userCorreo', usuario['correo']);
          print('✅ UserCorreo guardado: ${usuario['correo']}');
        }

        // Guardar roles
        if (usuario['roles'] != null &&
            usuario['roles'] is List &&
            usuario['roles'].isNotEmpty) {
          await prefs.setString('userRol', usuario['roles'][0]);
          await prefs.setStringList(
            'userRoles',
            List<String>.from(usuario['roles']),
          );
          print('✅ UserRol guardado: ${usuario['roles'][0]}');
        } else {
          await prefs.setString('userRol', 'Usuario');
          await prefs.setStringList('userRoles', ['Usuario']);
          print('⚠️ No se encontraron roles, usando "Usuario" por defecto');
        }
      }
    } catch (e) {
      print('❌ Error al guardar datos del usuario: $e');
    }
  }

  Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt('userId');
      if (userId == null) {
        print('❌ No se encontró userId en SharedPreferences');
        return null;
      }

      return {
        'id': userId,
        'nombre': prefs.getString('userNombre'),
        'correo': prefs.getString('userCorreo'),
        'rol': prefs.getString('userRol'),
        'roles': prefs.getStringList('userRoles'),
      };
    } catch (e) {
      print('❌ Error al obtener datos del usuario: $e');
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ Sesión cerrada correctamente');
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
    }
  }
}
