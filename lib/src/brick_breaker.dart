import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  BrickBreaker() : super(
    camera: CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  );

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    world.add(Ball(
      radius: ballRadius,
      position: size / 2,
      velocity: Vector2(
        (rand.nextDouble() - 0.5) * width,
        height * 0.2,
      ).normalized()..scale(height / 4),
    ));

    world.add(Bat(
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
      position: Vector2(width / 2, height * 0.95),
    ));

    debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)
        || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      world.children.query<Bat>().first.moveBy(-batStep);
    }
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)
             || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      world.children.query<Bat>().first.moveBy(batStep);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        //startGame();
    }

    return KeyEventResult.handled;
  }
}
