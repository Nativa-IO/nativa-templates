import 'dart:convert';

import 'package:http/http.dart' as http;

/// La URL pública de la API del proyecto. Llega por `--dart-define=API_URL`
/// (en el preview la pone docker-compose.dev.yml desde PUBLIC_API_URL; en
/// producción, el build de docker/app.Dockerfile). Vacía = sin backend.
const apiUrl = String.fromEnvironment('API_URL');

bool get hasApi => apiUrl.isNotEmpty;

/// `GET /health` del backend: el latido que confirma que app y API se ven.
/// Devuelve el JSON del backend, o lanza si no responde.
Future<Map<String, dynamic>> fetchHealth() async {
  final response = await http
      .get(Uri.parse('$apiUrl/health'))
      .timeout(const Duration(seconds: 6));
  if (response.statusCode != 200) {
    throw Exception('API respondió ${response.statusCode}');
  }
  final body = jsonDecode(response.body);
  return body is Map<String, dynamic> ? body : {'raw': body};
}
