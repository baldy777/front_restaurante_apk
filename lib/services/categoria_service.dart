import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_movil/models/productos.dart';

class CategoriaService {
  final String baseUrl =
      "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/categorias";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
      );

      print('Status code categorías: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Categoria.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }

  Future<Categoria?> obtenerCategoria(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Categoria.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al obtener categoría: $e');
      return null;
    }
  }

  Future<Categoria?> crearCategoria({
    required String nombre,
    String? descripcion,
  }) async {
    try {
      final body = {"nombre": nombre, "descripcion": descripcion};

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      print('Status code crear categoría: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Categoria.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al crear categoría: $e');
      return null;
    }
  }

  Future<Categoria?> actualizarCategoria({
    required int id,
    String? nombre,
    String? descripcion,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (nombre != null) body['nombre'] = nombre;
      if (descripcion != null) body['descripcion'] = descripcion;

      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Categoria.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al actualizar categoría: $e');
      return null;
    }
  }
}
