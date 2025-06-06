import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState {
  welcome,
  playing,
  gameOver,
  won,
}

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker() : super(
    camera: CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  );

  final ValueNotifier<int> score = ValueNotifier(0);

  final ValueNotifier<int> comboMultiplier = ValueNotifier(1);
  DateTime? lastBrickDestroyedTime;
  final Duration comboBreakTime = Duration(seconds: 1);

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;

    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    debugMode = false;

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) {
      return;
    }

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    resetGame();

    world.add(Ball(
      difficultyModifier: difficultyModifier,
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

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  void resetGame() {
    score.value = 0;
    comboMultiplier.value = 1;
    lastBrickDestroyedTime = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (comboMultiplier.value > 1) {
      final now = DateTime.now();

      if (lastBrickDestroyedTime != null
          && now.difference(lastBrickDestroyedTime!) > comboBreakTime) {
        comboMultiplier.value = 1;
      }
    }

    if (world.children.query<Bat>().isEmpty) {
      return;
    }

    var batSpeed = batStep;

    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;

    if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)
        || keysPressed.contains(LogicalKeyboardKey.shiftRight)) {
      batSpeed *= 0.5;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)
        || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      world.children.query<Bat>().first.moveBy(-batSpeed);
    }
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)
             || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      world.children.query<Bat>().first.moveBy(batSpeed);
    }
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }

    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xFFF2E8CF);

  void onBrickDestroyed() {
    checkGameWon();
    handleCombo();
    shakeScreen();
  }

  void checkGameWon() {
    if (world.children.query<Brick>().length == 1) {
      onGameWon();
    }
  }

  void onGameWon() {
    score.value += 10000;
    playState = PlayState.won;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
  }

  void handleCombo() {
    final now = DateTime.now();

    if (lastBrickDestroyedTime != null
        && now.difference(lastBrickDestroyedTime!) <= comboBreakTime) {
      comboMultiplier.value = (comboMultiplier.value + 1).clamp(1, 10);
    }

    var baseScore = 1 * 100;
    score.value += baseScore * comboMultiplier.value;
    lastBrickDestroyedTime = now;

    //print('Score: ${score.value}, Combo Multiplier: x${comboMultiplier}');
  }

  void shakeScreen({double intensity = 5.0, int duration = 300}) async {
    // Original camera position
    final originalPosition = camera.viewfinder.position.clone();

    // Calculate the number of shake updates
    var shakeUpdates = (duration / 16).ceil(); // Assuming ~60 FPS (16ms per frame)
    final rand = math.Random();

    for (var i = 0; i < shakeUpdates; i++) {
      // 16ms delay for ~60 FPS
      await Future.delayed(const Duration(milliseconds: 16));

      // Generate random x, y offsets within the shake intensity
      final offsetX = (rand.nextDouble() * 2 - 1) * intensity;
      final offsetY = (rand.nextDouble() * 2 - 1) * intensity;

      // Update the camera position
      camera.viewfinder.position = originalPosition + Vector2(offsetX, offsetY);
    }

    // Reset the camera position after the shake
    camera.viewfinder.position = originalPosition;
  }
}
