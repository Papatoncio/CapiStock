import 'dart:convert';

import 'package:capistock/models/category.dart';
import 'package:capistock/util/staticVariables.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  fetchCategories() async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/categories/getCategories';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 0) {
          final List<dynamic> categoriesJson = jsonResponse['object'];
          StaticVariables.categoriesList =
              categoriesJson.map((json) => Category.fromJson(json)).toList();
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

  String findNombreCategoriaById(int id) {
    // Use firstWhere to find the category by id
    try {
      return StaticVariables.categoriesList
          .firstWhere((category) => category.id == id)
          .nombre;
    } catch (e) {
      // Return null or handle cases where the category is not found
      return '';
    }
  }
}
