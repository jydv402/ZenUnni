import 'package:zen/components/open_app_drawer_button.dart';
import 'package:zen/zen_barrel.dart';

class ScoreCard extends ConsumerWidget {
  const ScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final userState = ref.watch(userProvider);
    final user = userState.value;
    final colors = ref.watch(appColorsProvider);
    final String score0 = score.value.toString();

    if (userState.isLoading || user == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final gender = user.gender;
    final avatar = user.avatar;

    return Padding(
      key: Key('scorecard'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OpenAppDrawerButton(),
          Row(
            spacing: 10,
            children: [
              //Score
              GestureDetector(
                onTap: () {
                  updatePgIndex(ref, 6);
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
                  updatePgIndex(ref, 7);
                },
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: gender == 0
                          ? AssetImage(males.values.elementAt(avatar))
                          : AssetImage(females.values.elementAt(avatar)),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
