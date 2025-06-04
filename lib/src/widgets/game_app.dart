import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'combo_card.dart';
import 'overlay_screen.dart';
import 'score_card.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  }

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
                child: Column(
                  children: [
                    SizedBox(
                      height: gameHeight * 0.03,
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScoreCard(score: game.score),
                            const SizedBox(width: 8),
                            ComboCard(comboMultiplier: game.comboMultiplier),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,

                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) => const OverlayScreen(
                                title: 'TAP TO PLAY',
                                subtitle: 'Use arrow keys, mouse drag, or swipe to move the paddle',
                              ),
                              PlayState.gameOver.name: (context, game) => const OverlayScreen(
                                title: 'GAME OVER',
                                subtitle: 'Tap to play again',
                              ),
                              PlayState.won.name: (context, game) => const OverlayScreen(
                                title: 'YOU WON!!!',
                                subtitle: 'Tap to play again',
                              ),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
