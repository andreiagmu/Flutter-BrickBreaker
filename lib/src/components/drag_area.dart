import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

// Handles drag events for an invisible region
class DragArea extends PositionComponent with DragCallbacks {
  final void Function(DragUpdateEvent) onDragUpdateEx;

  DragArea({
    required super.position,
    required super.size,
    required this.onDragUpdateEx,
  }) : super(anchor: Anchor.center, children: [RectangleHitbox()]) {
    final _ = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill; // Transparent hitbox
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    // Forward drag events to the shared handler
    onDragUpdateEx(event);
  }
}
