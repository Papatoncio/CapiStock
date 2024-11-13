import 'package:capistock/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut().then((value) {
                Navigator.of(context).pushReplacementNamed('/');
              });
            },
          ),
        ],
      ),
      drawer: const SideBarMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                height: 150, // Tamaño ajustado
                width: 150, // Tamaño ajustado
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido, estás autenticado',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Color(0xFF132436),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
