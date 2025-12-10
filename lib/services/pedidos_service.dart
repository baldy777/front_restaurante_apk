import 'dart:convert';
import 'package:app_movil/models/pedido_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PedidosApiService {
  final String baseUrl;

  PedidosApiService()
    : baseUrl = 'http://${dotenv.env['API_IP']}:${dotenv.env['API_PORT']}';

  Future<Map<String, dynamic>> crearPedido(Pedido pedido) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear pedido: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> obtenerPedidos({
    String? estado,
    int? usuarioId,
    int pagina = 1,
    int limite = 10,
  }) async {
    final queryParams = <String, String>{
      'pagina': pagina.toString(),
      'limite': limite.toString(),
    };
    if (estado != null) queryParams['estado'] = estado;
    if (usuarioId != null) queryParams['usuarioId'] = usuarioId.toString();

    final uri = Uri.parse(
      '$baseUrl/pedidos',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener pedidos');
    }
  }

  Future<Map<String, dynamic>> obtenerPedidoPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener pedido');
    }
  }

  Future<Map<String, dynamic>> actualizarPedido(
    int id,
    Map<String, dynamic> datos,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/pedidos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar pedido');
    }
  }

  Future<Map<String, dynamic>> cancelarPedido(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pedidos/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cancelar pedido');
    }
  }
}
