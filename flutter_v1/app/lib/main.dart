import 'package:flutter/material.dart';

void main() {
  runApp(const NativaApp());
}

class NativaApp extends StatelessWidget {
  const NativaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nativa Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nativa Flutter')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 64),
            SizedBox(height: 16),
            Text(
              'Tu app Flutter está viva.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text('Describe lo que quieres construir y Nativa lo arma aquí.'),
          ],
        ),
      ),
    );
  }
}
