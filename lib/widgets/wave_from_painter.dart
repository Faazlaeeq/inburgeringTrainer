// import 'dart:math';

// import 'package:flutter/material.dart';

// class WaveformPainter extends CustomPainter {
//   final double progress;
//   final Color color;

//   WaveformPainter({required this.progress, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 2.0;

//     // Draw waveform
//     for (int i = 0; i < size.width; i += 4) {
//       final double height =
//           (sin((i + progress * 100) / 10) + 1) / 2 * size.height;
//       canvas.drawLine(Offset(i.toDouble(), size.height),
//           Offset(i.toDouble(), size.height - height), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class WaveformAnimation extends StatefulWidget {
//   @override
//   _WaveformAnimationState createState() => _WaveformAnimationState();
// }

// class _WaveformAnimationState extends State<WaveformAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: WaveformPainter(progress: _controller.value),
//           size: Size(300, 100), // Replace with your actual size
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
