import 'package:lottie/lottie.dart';
import 'package:zen/zen_barrel.dart';

class LandPage extends ConsumerWidget {
  const LandPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNameProvider);
    final mood = ref.watch(moodProvider);

    return user.when(
      data: (data) {
        return homeScreen(context, ref, user.value, mood.value);
      },
      error: (error, stackTrace) {
        return Center(
          child: Text('Error: $error'),
        );
      },
      loading: () {
        return Center(
          child: showRunningIndicator(
              context, "Setting things up...\nJust for you..!"),
        );
      },
    );
  }

  Widget homeScreen(
      BuildContext context, WidgetRef ref, String? user, String? mood) {
    final colors = ref.watch(appColorsProvider);
    final userDetails = ref.watch(rankedUserSearchProvider).value;
    final now = DateTime.now().hour;
    final greeting = now < 12
        ? 'Morning'
        : now < 17
            ? 'Afternoon'
            : 'Evening';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      children: [
        //Top score card
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: const ScoreCard(),
        ),
        const SizedBox(height: 20),
        //Greeting text
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good $greeting,",
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(user!, style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),
        // Mood not added yet msg
        // if (mood == null)
        //   //Show add mood msg
        //   _msgContainer(
        //     context,
        //     "No mood added yet, add it now? 👀",
        //     () => updatePgIndex(ref, 5, 3),
        //   ),
        const SizedBox(height: 8),
        //TODO: Add a quote of the day, maybe?
        // Flex(
        //   direction: Axis.horizontal,
        //   children: [
        //     _bentos(
        //       context,
        //       1,
        //       () {},
        //       colors.pillClr,
        //       const EdgeInsets.fromLTRB(0, 0, 0, 8),
        //       Stack(
        //         children: [
        //           _bgText(-15, "Quote", colors.homeBgTxt, top: 25),
        //         ],
        //       ),
        //       height: 200,
        //     ),
        //   ],
        // ),
        //1st row
        Row(
          children: [
            _bentos(
              context,
              3,
              () {
                updatePgIndex(ref, 3, 3);
                ref.read(navStackProvider.notifier).push(3);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 0, 4, 4),
              Stack(
                children: [
                  _bgText(-8, "Mood", colors.homeBgTxt),
                  Center(
                    child: mood == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Lottie.asset(reversedMoodList["Empty"]!,
                                    height: 120, width: 120),
                                Text("So empty...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    textAlign: TextAlign.center),
                                Text(
                                  "Add a mood now?",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Lottie.asset(reversedMoodList[mood]!,
                                    height: 120, width: 120),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Mood :\n",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      TextSpan(
                                        text: mood,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            _bentos(
              context,
              2,
              () {
                updatePgIndex(ref, 6, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(4, 0, 0, 4),
              Stack(
                children: [
                  _bgText(-25, "Rank", colors.homeBgTxt),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //spacing: 26,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Lottie.asset("assets/emoji/trophy.json",
                            height: 100, width: 100),
                      ),
                      const SizedBox(height: 14),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Rank :\n",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: userDetails?.any((element) =>
                                          element.username == user) ==
                                      true
                                  ? "${userDetails!.firstWhere((element) => element.username == user).rank}"
                                  : "0",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextSpan(
                              text: " / ${userDetails?.length}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),

        //2nd row
        Row(
          children: [
            _bentos(
              context,
              2,
              () {
                ref.read(selectedTabProvider.notifier).state = 1;
                updatePgIndex(ref, 0, 0);
                ref.read(navStackProvider.notifier).push(0);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(0, 4, 4, 4),
              Stack(
                children: [
                  _bgText(-28, "Schedule", colors.homeBgTxt),
                ],
              ),
            ),
            _bentos(
              context,
              3,
              () {
                ref.read(selectedTabProvider.notifier).state = 0;
                updatePgIndex(ref, 0, 0);
                ref.read(navStackProvider.notifier).push(0);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(4, 4, 0, 4),
              Stack(
                children: [
                  _bgText(-15, "Tasks", colors.homeBgTxt),
                ],
              ),
            ),
          ],
        ),

        Row(
          children: [
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 1, 1);
                ref.read(navStackProvider.notifier).push(1);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 4, 4, 0),
              Stack(
                children: [
                  _bgText(-40, "Habits", colors.homeBgTxt),
                ],
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 4, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(4, 4, 0, 0),
              Stack(
                children: [
                  _bgText(-25, "Profile", colors.homeBgTxt),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 26, 2),
          child: Text(
            "Extras",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          children: [
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 7, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 4, 4, 0),
              Stack(
                children: [
                  _bgText(-10, "Pomodoro", colors.homeBgTxt),
                ],
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 9, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(4, 4, 0, 0),
              Stack(
                children: [
                  _bgText(-22, "Notes", colors.homeBgTxt),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 85),
      ],
    );
  }

  Widget _bentos(BuildContext context, int flex, GestureTapCallback onTap,
      Color color, EdgeInsets margin, Widget child,
      {double? height}) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26), color: color),
          height: height ?? 250,
          width: MediaQuery.sizeOf(context).width,
          child: child,
        ),
      ),
    );
  }

  Positioned _bgText(double left, String label, Color color, {double? top}) {
    return Positioned(
      top: top ?? 40,
      left: left,
      child: Text(
        label,
        softWrap: false,
        style: TextStyle(
            fontFamily: "Pop",
            fontSize: 100,
            letterSpacing: -5,
            fontWeight: FontWeight.w600,
            color: color),
      ),
    );
  }

  GestureDetector _msgContainer(
      BuildContext context, String msg, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white30,
        ),
        child: Text(msg, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
