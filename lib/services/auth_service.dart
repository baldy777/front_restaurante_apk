import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }
}
