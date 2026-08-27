import 'package:flutter/material.dart';

// Pantalla de bienvenida de Nativa: placeholder autocontenido que el primer
// build del proyecto reemplaza. Todo vive en este archivo a propósito.

// Wiring-ready: si algún día el template pasa --dart-define=PROJECT_NAME=...,
// se usa; mientras tanto aplica el fallback.
const projectName = String.fromEnvironment(
  'PROJECT_NAME',
  defaultValue: 'Tu proyecto Nativa',
);

const _bg = Color(0xFF090909);
const _surface = Color(0xFF101010);
const _text = Color(0xFFE6EDF3);
const _muted = Color(0xFF8A919C);
const _violet = Color(0xFFA78BFA);
const _green = Color(0xFF3FB950);

void main() {
  runApp(const NativaApp());
}

class NativaApp extends StatelessWidget {
  const NativaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: projectName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
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
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0x14FFFFFF)),
                        ),
                        child: const Text(
                          'N',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: _violet,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Nativa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          color: _text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    projectName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1F3FB950),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0x663FB950)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 7,
                          height: 7,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'App corriendo ✓',
                          style: TextStyle(fontSize: 14, color: _green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const SizedBox(
                    width: 420,
                    child: Text(
                      'Tu proyecto está vivo. Pide tu primer cambio desde el '
                      'chat de la sesión en Nativa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.6, color: _muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // rgba(120,128,140,.10), celda de 24px — el grid sutil de la marca.
    final paint = Paint()..color = const Color(0x1A78808C);
    const cell = 24.0;
    for (var x = cell / 2; x < size.width; x += cell) {
      for (var y = cell / 2; y < size.height; y += cell) {
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
