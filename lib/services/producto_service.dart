import 'dart:convert';
import 'package:app_movil/models/productos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductoService {
  final String baseUrl =
      "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/productos";

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

  // Obtener todos los productos
  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
      );

      print('Status code productos: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  // Obtener solo productos activos
  Future<List<Producto>> obtenerProductosActivos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activos'),
        headers: await _getHeaders(),
      );

      print('Status code productos activos: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error al obtener productos activos: $e');
      return [];
    }
  }

  // Obtener un producto por ID
  Future<Producto?> obtenerProducto(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Producto.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al obtener producto: $e');
      return null;
    }
  }

  // Crear producto (sin imagen por ahora)
  Future<Producto?> crearProducto({
    required String nombre,
    String? descripcion,
    required double precio,
    int? disponibilidad,
    required int subcategoriaId,
  }) async {
    try {
      final body = {
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "disponibilidad": disponibilidad,
        "subcategoria": subcategoriaId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/upload'), // Endpoint correcto
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      print('Status code crear: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Producto.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al crear producto: $e');
      return null;
    }
  }

  // Actualizar producto
  Future<Producto?> actualizarProducto({
    required int id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? disponibilidad,
    int? subcategoriaId,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (nombre != null) body['nombre'] = nombre;
      if (descripcion != null) body['descripcion'] = descripcion;
      if (precio != null) body['precio'] = precio;
      if (disponibilidad != null) body['disponibilidad'] = disponibilidad;
      if (subcategoriaId != null) body['subcategoria'] = subcategoriaId;

      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      print('Status code actualizar: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Producto.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print('Error al actualizar producto: $e');
      return null;
    }
  }

  // Cambiar estado activo/inactivo
  Future<bool> cambiarEstado(int id, bool activo) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id/estado'),
        headers: await _getHeaders(),
        body: jsonEncode({'activo': activo}),
      );

      print('Status code cambiar estado: ${response.statusCode}');

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error al cambiar estado: $e');
      return false;
    }
  }

  // Soft delete (desactivar producto)
  Future<bool> eliminarProducto(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error al eliminar producto: $e');
      return false;
    }
  }
}
