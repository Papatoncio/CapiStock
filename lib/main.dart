import 'package:capistock/api/firebaseapi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primaryColor: const Color(0xFFEE891A), // Color principal (#ed4103)
        primaryColorLight: const Color(0xFFEE891A), // Color de acento (#ee891a)
        scaffoldBackgroundColor:
            const Color(0xFF132436), // Fondo principal (#132436)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF132436),
            backgroundColor: Color(0xFFF8FADD),
          ), // Texto blanco por defecto
          bodyMedium: TextStyle(
            color: Color(0xFF132436),
            backgroundColor: Color(0xFFF8FADD),
          ),
          bodySmall: TextStyle(
            color: Color(0xFF132436),
            backgroundColor: Color(0xFFF8FADD),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor:
              const Color(0xFFF8FADD), // Fondo de los campos de texto (#f8fadd)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              color: Color(0xFFEE891A), // Botón con color (#ee891a)
            ),
            backgroundColor: const Color(0xFFF8FADD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color(0xFFEE891A), // Color de la barra superior (#ed4103)
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
