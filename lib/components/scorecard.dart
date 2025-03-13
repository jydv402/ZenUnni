import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class ScoreCard extends ConsumerWidget {
  const ScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final String score0 = score.value.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 26, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white12,
          ),
          child: score0 == "null"
              ? Text(
                  "🏆    0",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              : Text(
                  "🏆    $score0",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ),
      ],
    );
  }
}
