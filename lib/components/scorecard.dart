import 'package:zen/zen_barrel.dart';

class ScoreCard extends ConsumerWidget {
  const ScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final String score0 = score.value.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 10,
      children: [
        //Score
        GestureDetector(
          onTap: () {
            updatePgIndex(ref, 6, 4);
            ref.read(navStackProvider.notifier).push(4);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 26, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.black12,
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
        ),
        GestureDetector(
          onTap: () {
            updatePgIndex(ref, 4, 4);
            ref.read(navStackProvider.notifier).push(4);
          },
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icon/avt.png'),
              ),
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}
