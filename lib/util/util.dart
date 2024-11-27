import 'package:capistock/util/staticVariables.dart';
import 'package:flutter/material.dart';

class Util {
  static void showSnackBar(String msg) {
    ScaffoldMessenger.of(StaticVariables.navState.currentState!.context)
        .showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  static void showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(StaticVariables.navState.currentState!.context)
        .showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  static bool isValidImageUrl(String path) {
    // Expresión regular para verificar si la ruta es una URL
    final Uri? uri = Uri.tryParse(path);
    if (uri != null && uri.hasAbsolutePath) {
      // Verificar si la URL comienza con 'http' o 'https'
      return (uri.scheme == 'http' || uri.scheme == 'https') &&
          (uri.path.isNotEmpty);
    }
    return false;
  }
}
