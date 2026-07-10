import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformWidget extends StatefulWidget {
  final bool isLive;

  const WaveformWidget({Key? key, this.isLive = true}) : super(key: key);

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _amplitudes = List.generate(24, (index) => 0.1 + Random().nextDouble() * 0.8);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        if (widget.isLive) {
          setState(() {
            // Shift amplitudes left and add a new random one at the end
            for (int i = 0; i < _amplitudes.length - 1; i++) {
              _amplitudes[i] = _amplitudes[i + 1];
            }
            _amplitudes[_amplitudes.length - 1] = 0.15 + _random.nextDouble() * 0.85;
          });
        }
      });

    if (widget.isLive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(
        painter: _WaveformPainter(
          amplitudes: _amplitudes,
          color: AppTheme.accent,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  _WaveformPainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double spacing = 4.0;
    final int barCount = amplitudes.length;
    final double totalSpacing = spacing * (barCount - 1);
    final double barWidth = (size.width - totalSpacing) / barCount;

    for (int i = 0; i < barCount; i++) {
      final double amp = amplitudes[i];
      final double barHeight = size.height * amp;
      final double x = i * (barWidth + spacing);
      final double y = (size.height - barHeight) / 2;

      // Draw rounded rectangle for each bar
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return true; // Redraw whenever amplitudes change
  }
}
