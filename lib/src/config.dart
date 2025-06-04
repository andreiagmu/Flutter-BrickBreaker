import 'package:flutter/material.dart';

const brickColors = [
  Color(0xFFF94144),
  Color(0xFFF3722C),
  Color(0xFFF8961E),
  Color(0xFFF9844A),
  Color(0xFFF9c74F),
  Color(0xFF90BE6D),
  Color(0xFF43AA8B),
  Color(0xFF4D908E),
  Color(0xFF277DA1),
  Color(0xFF577590),
];

const gameWidth = 820.0;
const gameHeight = 1600.0;

const ballRadius = gameWidth * 0.02;

const batWidth = gameWidth * 0.2;
const batHeight = ballRadius * 2;
const batStep = gameWidth * 0.03;

const brickGutter = gameWidth * 0.015;
final brickWidth =
    (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
const brickHeight = gameHeight * 0.03;

const difficultyModifier = 1.03;
