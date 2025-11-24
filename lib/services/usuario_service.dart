import 'dart:convert';

import 'package:app_movil/models/usuarios.dart';
import 'package:http/http.dart' as http;

class UsuarioApiGet {
  final String apiUrl = 'http://10.0.2.2:3000/usuarios';

  Future<List<Usuarios>> obtenerUsuarios() async {
    print("llamado a la api");
    final response = await http.get(Uri.parse(apiUrl));

    print("respuesta de la api: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((json) => Usuarios.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los usuarios');
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
    final url = Uri.parse("http://10.0.2.2:3000/usuarios");

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
