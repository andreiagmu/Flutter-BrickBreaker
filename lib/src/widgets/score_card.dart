import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.score});

  final ValueNotifier<int> score;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, score, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
          child: Text(
            'Score: $score'.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge!,
          )
              .animate(key: ValueKey(score))
              .scale(begin: Offset(1.0, 1.0), end: Offset(1.1, 1.1), duration: 100.ms)
              .then()
              .scale(begin: Offset(1.1, 1.1), end: Offset(1.0, 1.0), duration: 100.ms),
        );
      },
    );
  }
}
