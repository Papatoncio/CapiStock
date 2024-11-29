import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<void> saveDevice(deviceData) async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/notifications/saveDevice/';

    try {
      final response = await http.post(Uri.parse(url), body: deviceData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 0) {
          // print(jsonResponse['message']);
        } else {
          throw Exception('Error en la respuesta del servidor.');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Ruta no encontrada en el servidor (404).');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al realizar la solicitud: $error');
    }
  }
}
