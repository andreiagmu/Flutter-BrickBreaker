import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xFF184E77),
          displayColor: const Color(0xFF184E77),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFA9D6E5),
                Color(0xFFF2E8CF),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: FittedBox(
                  child: SizedBox(
                    width: gameWidth,
                    height: gameHeight,

                    child: GameWidget.controlled(
                      gameFactory: BrickBreaker.new,
                      overlayBuilderMap: {
                        PlayState.welcome.name: (context, game) => Center(
                          child: Text(
                            'TAP TO PLAY',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        PlayState.gameOver.name: (context, game) => Center(
                          child: Text(
                            'GAME OVER',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        PlayState.won.name: (context, game) => Center(
                          child: Text(
                            'YOU WON!!!',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
