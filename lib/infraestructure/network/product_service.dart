import 'dart:convert';
import 'dart:io';

import 'package:capistock/models/product.dart';
import 'package:capistock/util/util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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

  Future<void> updateProduct(
      File productImage, Map<String, dynamic> productData, productId) async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/products/updateProduct/${productId.toString()}';

    // Crear un objeto multipart request
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    // Adjuntar el archivo
    if (!productImage.path.startsWith('http')) {
      var fileStream = http.ByteStream(productImage.openRead());
      var fileLength = await productImage.length();
      var multipartFile = http.MultipartFile(
        'productImage', // Clave del archivo en form-data
        fileStream,
        fileLength,
        filename: path.basename(productImage.path), // Nombre del archivo
      );
      request.files.add(multipartFile);
    }

    // Adjuntar el JSON como un campo de texto
    request.fields['product'] = jsonEncode(productData);

    // Agregar encabezados si es necesario (opcional)
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    // Enviar la solicitud
    var response = await request.send();

    // Manejar la respuesta
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      // Decodificar la respuesta JSON y extraer el mensaje
      final responseJson = jsonDecode(responseData);
      final message = responseJson['message'] ?? 'Error desconocido';
      Util.showSnackBar(message);
    } else {
      print('Error al subir el producto. Código: ${response.statusCode}');
    }
  }

  Future<void> saveProduct(
      File productImage, Map<String, dynamic> productData) async {
    String url =
        '${dotenv.get('BASE_URL', fallback: '')}api/products/saveProduct/';
    // Crear un objeto multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Adjuntar el archivo
    var fileStream = http.ByteStream(productImage.openRead());
    var fileLength = await productImage.length();
    var multipartFile = http.MultipartFile(
      'productImage', // Clave del archivo en form-data
      fileStream,
      fileLength,
      filename: path.basename(productImage.path), // Nombre del archivo
    );
    request.files.add(multipartFile);

    // Adjuntar el JSON como un campo de texto
    request.fields['product'] = jsonEncode(productData);

    // Agregar encabezados si es necesario (opcional)
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    // Enviar la solicitud
    var response = await request.send();

    // Manejar la respuesta
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      // Decodificar la respuesta JSON y extraer el mensaje
      final responseJson = jsonDecode(responseData);
      final message = responseJson['message'] ?? 'Error desconocido';
      Util.showSnackBar(message);
    } else {
      print('Error al subir el producto. Código: ${response.statusCode}');
    }
  }
}
