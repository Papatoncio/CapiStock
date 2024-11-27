import 'dart:convert';

import 'package:capistock/models/product.dart';
import 'package:capistock/util/util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Product>> fetchProducts() async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/products/getProducts';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 0) {
          final List<dynamic> productsJson = jsonResponse['object'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
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

  void updateProduct(updatedProduct, productId) async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/products/updateProduct/${productId.toString()}';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: updatedProduct,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 0) {
          Util.showSnackBar(jsonResponse['message']);
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
