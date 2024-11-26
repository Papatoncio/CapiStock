import 'dart:convert'; // For jsonDecode

import 'package:capistock/api/firebaseapi.dart';
import 'package:capistock/infraestructure/network/category_service.dart';
import 'package:capistock/util/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_theme_plus/json_theme_plus.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  final lightThemeStr =
      await rootBundle.loadString('assets/appainter_light_theme.json');
  final lightThemeJson = jsonDecode(lightThemeStr);
  final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;

  final darkThemeStr =
      await rootBundle.loadString('assets/appainter_dark_theme.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

  await dotenv.load(fileName: ".env");

  loadParams();

  runApp(MyApp(
    theme: lightTheme,
    themeDark: darkTheme,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  final ThemeData themeDark;

  const MyApp({Key? key, required this.theme, required this.themeDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: theme,
      darkTheme: themeDark,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: Routes().routes,
    );
  }
}

loadParams() {
  CategoryService categoryService = new CategoryService();

  categoryService.fetchCategories();
}
