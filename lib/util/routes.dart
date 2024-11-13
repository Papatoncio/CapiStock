import 'package:capistock/screens/home_screen.dart';
import 'package:capistock/screens/login_screen.dart';
import 'package:capistock/screens/register_screen.dart';

class Routes {
  final routes = {
    '/': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/home': (context) => HomeScreen(),
  };
}
