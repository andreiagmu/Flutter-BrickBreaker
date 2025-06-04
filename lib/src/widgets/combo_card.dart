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
            child: Text(
              'Combo\nx$comboMultiplier',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
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
