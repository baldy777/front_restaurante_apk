import 'dart:convert';
import 'package:app_movil/models/productos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoriaService {
  final String baseUrl =
      "http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}/subcategorias";

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

  Future<List<SubCategoria>> obtenerSubcategorias() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SubCategoria.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error al obtener subcategorías: $e');
      return [];
    }
  }

  Future<List<SubCategoria>> obtenerSubcategoriasPorCategoria(
    int categoriaId,
  ) async {
    try {
      final subcategorias = await obtenerSubcategorias();
      return subcategorias
          .where((sub) => sub.categoriaId == categoriaId)
          .toList();
    } catch (e) {
      print('Error al filtrar subcategorías: $e');
      return [];
    }
  }
}
