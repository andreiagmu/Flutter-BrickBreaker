import 'package:flutter/material.dart';

class ComboCard extends StatelessWidget {
  const ComboCard({super.key, required this.comboMultiplier});

  final ValueNotifier<int> comboMultiplier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: comboMultiplier,
      builder: (context, comboMultiplier, child) {
        if (comboMultiplier > 1) {
          // Display if comboMultiplier is greater than 1.
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Combo x$comboMultiplier',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        // If comboMultiplier is 1, show nothing.
        return const SizedBox.shrink();
      },
    );
  }
}
