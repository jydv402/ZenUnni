import 'package:zen/zen_barrel.dart';

class ScoreCard extends ConsumerWidget {
  const ScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final user = ref.watch(userProvider);
    final colors = ref.watch(appColorsProvider);
    final String score0 = score.value.toString();
    return Row(
      key: Key('scorecard'),
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
              color: colors.pillClr,
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
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: user.value!.gender == 0
                    ? AssetImage(
                        males.values.elementAt(user.value!.avatar),
                      )
                    : AssetImage(
                        females.values.elementAt(user.value!.avatar),
                      ),
              ),
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}
