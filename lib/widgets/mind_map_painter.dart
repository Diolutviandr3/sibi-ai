import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MindMapNode {
  final String id;
  final String label;
  final Offset position; // normalized coordinates from -1 to 1

  MindMapNode({
    required this.id,
    required this.label,
    required this.position,
  });
}

class MindMapWidget extends StatefulWidget {
  final Function(String)? onNodeTapped;

  const MindMapWidget({Key? key, this.onNodeTapped}) : super(key: key);

  @override
  State<MindMapWidget> createState() => _MindMapWidgetState();
}

class _MindMapWidgetState extends State<MindMapWidget> {
  String selectedNodeId = 'center';

  final List<MindMapNode> nodes = [
    MindMapNode(id: 'center', label: 'Arsitektur Komputer', position: const Offset(0.0, 0.0)),
    MindMapNode(id: 'cpu', label: 'CPU / Prosesor', position: const Offset(-0.7, -0.6)),
    MindMapNode(id: 'memory', label: 'Hierarki Memori', position: const Offset(0.7, -0.6)),
    MindMapNode(id: 'io', label: 'Input / Output', position: const Offset(-0.7, 0.6)),
    MindMapNode(id: 'interconnect', label: 'System interconnect', position: const Offset(0.7, 0.6)),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        // Map normalized coordinates (-1 to 1) to actual pixel positions
        Offset getOffset(Offset normalized) {
          final double x = (normalized.dx + 1.0) / 2.0 * width;
          final double y = (normalized.dy + 1.0) / 2.0 * height;
          return Offset(x, y);
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF001E3D), // Deep dark blue canvas
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // 1. Draw connection lines
              Positioned.fill(
                child: CustomPaint(
                  painter: _ConnectionPainter(
                    center: getOffset(const Offset(0.0, 0.0)),
                    targets: [
                      getOffset(const Offset(-0.7, -0.6)),
                      getOffset(const Offset(0.7, -0.6)),
                      getOffset(const Offset(-0.7, 0.6)),
                      getOffset(const Offset(0.7, 0.6)),
                    ],
                  ),
                ),
              ),

              // 2. Interactive Zoom buttons (overlays top right)
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    _buildZoomButton(Icons.zoom_in),
                    const SizedBox(width: 6),
                    _buildZoomButton(Icons.zoom_out),
                    const SizedBox(width: 6),
                    _buildZoomButton(Icons.fullscreen),
                  ],
                ),
              ),

              // 3. Render Nodes
              ...nodes.map((node) {
                final isCenter = node.id == 'center';
                final isSelected = selectedNodeId == node.id;
                final offset = getOffset(node.position);

                // Nodes size
                final double nodeWidth = isCenter ? 140 : 120;
                final double nodeHeight = isCenter ? 60 : 50;

                return Positioned(
                  left: offset.dx - (nodeWidth / 2),
                  top: offset.dy - (nodeHeight / 2),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedNodeId = node.id;
                      });
                      if (widget.onNodeTapped != null) {
                        widget.onNodeTapped!(node.label);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: nodeWidth,
                      height: nodeHeight,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCenter
                            ? (isSelected ? AppTheme.accent : const Color(0xFF0F172A))
                            : (isSelected ? AppTheme.accent : const Color(0xFF0252D7)),
                        border: Border.all(
                          color: isSelected ? Colors.white : (isCenter ? const Color(0xFF38BDF8) : Colors.transparent),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [BoxShadow(color: AppTheme.accent.withOpacity(0.5), blurRadius: 12)]
                            : [],
                      ),
                      child: Text(
                        node.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isCenter ? 13 : 12,
                            ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoomButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  final Offset center;
  final List<Offset> targets;

  _ConnectionPainter({required this.center, required this.targets});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintArrow = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (final target in targets) {
      // Draw connection line
      canvas.drawLine(center, target, paintLine);

      // Draw arrow head at the target pointing away from center
      final double angle = atan2(target.dy - center.dy, target.dx - center.dx);
      
      // We want to pull back the arrow head slightly so it sits at the edge of the node, not the center
      const double pullbackDistance = 32.0; 
      final double arrowX = target.dx - pullbackDistance * cos(angle);
      final double arrowY = target.dy - pullbackDistance * sin(angle);
      final arrowTarget = Offset(arrowX, arrowY);

      final double arrowSize = 8.0;
      final path = Path()
        ..moveTo(arrowTarget.dx, arrowTarget.dy)
        ..lineTo(
          arrowTarget.dx - arrowSize * cos(angle - pi / 6),
          arrowTarget.dy - arrowSize * sin(angle - pi / 6),
        )
        ..lineTo(
          arrowTarget.dx - arrowSize * cos(angle + pi / 6),
          arrowTarget.dy - arrowSize * sin(angle + pi / 6),
        )
        ..close();

      canvas.drawPath(path, paintArrow);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) {
    return oldDelegate.center != center || oldDelegate.targets.length != targets.length;
  }
}
