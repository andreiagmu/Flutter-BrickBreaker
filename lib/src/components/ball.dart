import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()
           ..color = const Color(0xFF1E6091)
           ..style = PaintingStyle.fill,
         children: [CircleHitbox()],
  );

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);

    // Update the ball's position
    position += velocity * dt;

    // Clamp the ball within the play area boundaries, except at the bottom
    position.x = position.x.clamp(0 + radius, game.width);
    position.y = position.y.clamp(0 + radius, double.nan);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
        wallBounceCommonBehavior();
      }
      else if (intersectionPoints.first.x <= 0
          || intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
        wallBounceCommonBehavior();
      }
      else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
          delay: 0.35,
          onComplete: () {
            game.playState = PlayState.gameOver;
          },
        ));
      }
    }
    else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;

      game.shakeScreen(intensity: 2.0, duration: 100);
    }
    else if (other is Brick) {
      if (position.y < other.position.y - other.size.y / 2
          || position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      }
      else if (position.x < other.position.x
          || position.x > other.position.x) {
        velocity.x = -velocity.x;
      }

      velocity.setFrom(velocity * difficultyModifier);
    }
    else {
      debugPrint('collision with $other');
    }
  }

  void wallBounceCommonBehavior() {
    game.shakeScreen(intensity: 2.0, duration: 100);
  }
}
