import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'drag_area.dart';

class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center) {
    // Add a hitbox for the visible bat
    add(RectangleHitbox());

    // Add an invisible "drag area" below the bat
    final dragAreaOffset = size.y;
    add(DragArea(
      position: Vector2(0, size.y / 2 + dragAreaOffset / 2),
      size: Vector2(size.x, dragAreaOffset),
      onDragUpdateEx: _handleDragUpdate,
    ));
  }

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color(0xFF1E6091)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size.toSize(), cornerRadius),
      _paint,
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _handleDragUpdate(event);
  }

  // Shared drag logic for the bat and extra drag area
  void _handleDragUpdate(DragUpdateEvent event) {
    if (isRemoved) {
      return;
    }

    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  void moveBy(double dx) {
    if (position.x + dx >= 0 && position.x + dx <= game.width) {
      add(
        MoveToEffect(
          Vector2((position.x + dx).clamp(0, game.width), position.y),
          EffectController(duration: 0.1),
        ),
      );
    }

    if (position.x < 0) {
      position.x = 0;
    }
    else if (position.x > game.width) {
      position.x = game.width;
    }
  }
}
