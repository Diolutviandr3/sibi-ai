import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CircularGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String percentageText;
  final String amountText;
  final String label;
  final String leftMetricLabel;
  final String leftMetricValue;
  final String rightMetricLabel;
  final String rightMetricValue;

  const CircularGauge({
    Key? key,
    required this.value,
    required this.percentageText,
    required this.amountText,
    required this.label,
    required this.leftMetricLabel,
    required this.leftMetricValue,
    required this.rightMetricLabel,
    required this.rightMetricValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 140,
              width: 220,
              child: CustomPaint(
                painter: _GaugePainter(
                  value: value,
                  color: AppTheme.accent,
                  trackColor: AppTheme.border,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      percentageText,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    Text(
                      amountText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.border),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$leftMetricLabel: $leftMetricValue',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$rightMetricLabel: $rightMetricValue',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color trackColor;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = min(size.width / 2 - 12, size.height - 20);

    final paintTrack = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final paintProgress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Semicircle gauge: goes from 180 degrees (π rad) to 360 degrees (2π rad)
    // To make it look like a nice gauge, let's start at 190 deg (-170 deg) and sweep 200 deg.
    const startAngle = pi - 0.2;
    const totalSweep = pi + 0.4;
    final sweepAngle = totalSweep * value;

    // Draw track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      paintTrack,
    );

    // Draw progress
    if (value > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paintProgress,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}
