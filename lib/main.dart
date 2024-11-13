import 'package:capistock/api/firebaseapi.dart';
import 'package:capistock/util/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'util/apptheme.dart';
import 'package:json_theme_plus/json_theme_plus.dart';

import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: theme,
      initialRoute: '/',
      routes: Routes().routes,
    );
  }
}
