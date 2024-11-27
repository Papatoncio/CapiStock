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
}
