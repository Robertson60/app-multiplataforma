import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const LilyApp());

class LilyApp extends StatelessWidget {
  const LilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flor Lily', home: const LilyHome());
  }
}

class LilyHome extends StatefulWidget {
  const LilyHome({super.key});

  @override
  State<LilyHome> createState() => _LilyHomeState();
}

class _LilyHomeState extends State<LilyHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 150.0,
      end: 220.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo nocturno
      appBar: AppBar(title: const Text("Flor Lily en Flutter")),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(400, 400),
                  painter: LilyPainter(radius: _animation.value),
                ),
                const SizedBox(height: 20),
                const Text(
                  "🌸 Lindo día Liz 🌸",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LilyPainter extends CustomPainter {
  final double radius;
  LilyPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Fondo nocturno con estrellas
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final starPaint = Paint()..color = Colors.white;
    final random = Random();
    for (int i = 0; i < 50; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), 1.5, starPaint);
    }

    // Luna
    final moonPaint = Paint()..color = Colors.yellow.shade200;
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      40,
      moonPaint,
    );

    // Flor Lily
    final petalPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(255, 231, 106, 235);

    const petalCount = 10;

    for (int i = 0; i < petalCount; i++) {
      final angle = (2 * pi / petalCount) * i;
      final petalPath = Path();

      petalPath.moveTo(center.dx, center.dy);

      petalPath.quadraticBezierTo(
        center.dx + radius * cos(angle - 0.3),
        center.dy + radius * sin(angle - 0.3),
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      petalPath.quadraticBezierTo(
        center.dx + radius * cos(angle + 0.3),
        center.dy + radius * sin(angle + 0.3),
        center.dx,
        center.dy,
      );

      canvas.drawPath(petalPath, petalPaint);
    }

    // Centro de la flor
    final centerPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, centerPaint);
  }

  @override
  bool shouldRepaint(covariant LilyPainter oldDelegate) =>
      oldDelegate.radius != radius;
}
