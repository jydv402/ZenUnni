import 'package:flutter/gestures.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zen/zen_barrel.dart';

class LandPage extends ConsumerWidget {
  const LandPage({super.key});

  List habitsCompleted(List<HabitModel> habits) {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    if (habits.isEmpty) {
      // No habits added yet
      return ["assets/emoji/hatching.json", "No habits added yet\nAdd some!"];
    } else if (habits.every(
      // Habits exists. check if all are completed
      (habit) =>
          habit.completedDates.containsKey(dateOnly) &&
          habit.completedDates[dateOnly]!,
    )) {
      // All habits completed
      return ["assets/emoji/hatched.json", "All habits completed"];
    } else {
      // Incomplete habits exist
      return ["assets/emoji/hatching.json", "You have habits left to complete"];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider).value;
    final profile = ref.watch(userProvider).value;
    final mood = ref.watch(moodProvider).value;

    if (userName == null || profile == null) {
      return Center(
        child: showRunningIndicator(
          context,
          "Setting things up...\nJust for you..!",
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: homeScreen(context, ref, userName, mood),
    );
  }

  Widget homeScreen(
    BuildContext context,
    WidgetRef ref,
    String? user,
    String? mood,
  ) {
    final colors = ref.watch(appColorsProvider);
    //For rank card
    final rankDetails = ref.watch(rankedUserSearchProvider).value;
    //For profile card
    final profileDetails = ref.watch(userProvider).value;
    //For habit card
    final habitDetails = ref.watch(habitProvider).value ?? [];

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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const ScoreCard(),
        ),
        //Greeting text
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good $greeting,",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(user!, style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),

        Flex(
          direction: Axis.horizontal,
          children: [
            _bentos(
              context,
              1,
              () {
                Navigator.pushNamed(context, "/chat");
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 0, 0, 8),
              Stack(
                children: [
                  _bgText(-15, "Chat", colors.homeBgTxt, top: 25),
                  Center(
                    child: Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/loading/ld_shapes.json",
                          height: 80,
                          width: 80,
                        ),
                        Text(
                          "Unni",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 110,
                                color: Colors.blue.shade200,
                                letterSpacing: -7,
                              ),
                        ),
                        const SizedBox(width: 2),
                      ],
                    ),
                  ),
                ],
              ),
              height: 200,
            ),
          ],
        ),
        //1st row
        Row(
          children: [
            _bentos(
              context,
              3,
              () {
                updatePgIndex(ref, 3);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 0, 4, 4),
              Stack(
                children: [
                  _bgText(-20, "Mood", colors.homeBgTxt),
                  Center(
                    child: mood == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Lottie.asset(
                                  reversedMoodList["Empty"]!,
                                  height: 120,
                                  width: 120,
                                ),
                                Text(
                                  "So empty...",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
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
                                Lottie.asset(
                                  reversedMoodList[mood]!,
                                  height: 120,
                                  width: 120,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Mood :\n",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      TextSpan(
                                        text: mood,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
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
                updatePgIndex(ref, 6);
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
                        child: Lottie.asset(
                          "assets/emoji/trophy.json",
                          height: 100,
                          width: 100,
                        ),
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
                              text:
                                  rankDetails?.any(
                                        (element) => element.username == user,
                                      ) ==
                                      true
                                  ? "${rankDetails!.firstWhere((element) => element.username == user).rank}"
                                  : "0",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: " / ${rankDetails?.length}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        //2nd row
        Row(
          children: [
            _bentos(
              context,
              2,
              () {
                ref.read(selectedTabProvider.notifier).setTab(1);
                updatePgIndex(ref, 1);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(0, 4, 4, 4),
              Stack(
                children: [
                  _bgText(-28, "Schedule", colors.homeBgTxt),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Lottie.asset(
                          "assets/emoji/magic.json",
                          height: 120,
                          width: 120,
                        ),
                        Text(
                          // "Generate a\nschedule",
                          "Craft a schedule",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _bentos(
              context,
              3,
              () {
                ref.read(selectedTabProvider.notifier).setTab(0);
                updatePgIndex(ref, 1);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(4, 4, 0, 4),
              Stack(
                children: [
                  _bgText(-15, "Tasks", colors.homeBgTxt),
                  Center(
                    child: Column(
                      spacing: 22,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/emoji/rocket.json",
                          height: 120,
                          width: 120,
                        ),
                        Text(
                          "Track your tasks",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
                updatePgIndex(ref, 2);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 4, 4, 0),
              Stack(
                children: [
                  _bgText(-40, "Habits", colors.homeBgTxt),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 6),
                        Lottie.asset(
                          habitsCompleted(habitDetails)[0],
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          habitsCompleted(habitDetails)[1],
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 7);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(4, 4, 0, 0),
              Stack(
                children: [
                  _bgText(-25, "Profile", colors.homeBgTxt),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 13,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: profileDetails?.gender == 0
                                  ? AssetImage(
                                      males.values.elementAt(
                                        profileDetails!.avatar,
                                      ),
                                    )
                                  : AssetImage(
                                      females.values.elementAt(
                                        profileDetails!.avatar,
                                      ),
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: profileDetails.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "\nGo to profile",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 26, 2),
          child: Text("Extras", style: Theme.of(context).textTheme.titleMedium),
        ),
        Row(
          children: [
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 4);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 4, 4, 0),
              Stack(
                children: [
                  _bgText(-10, "Pomodoro", colors.homeBgTxt),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/emoji/pomo.json",
                          height: 150,
                          width: 150,
                        ),
                        Text(
                          "Pomodoro",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "Start a new\nfocus session",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 5);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(4, 4, 0, 0),
              Stack(
                children: [
                  _bgText(-22, "Notes", colors.homeBgTxt),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 18),
                        Lottie.asset(
                          "assets/emoji/note.json",
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Notes",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "Add a\nnew note",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Footer text
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 10),
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontFamily: "Pop", height: 1.1),
              children: [
                TextSpan(
                  text: "ZenUnni",
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width * 0.18,
                    fontWeight: FontWeight.bold,
                    color: colors.footer,
                  ),
                ),
                TextSpan(
                  text: "\nFind us ",
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: colors.footer,
                  ),
                ),
                TextSpan(
                  text: "here!",
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.withValues(alpha: 0.45),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                        Uri.parse("https://github.com/jydv402/ZenUnni"),
                        mode: LaunchMode.platformDefault,
                      );
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 85),
      ],
    );
  }

  Widget _bentos(
    BuildContext context,
    int flex,
    GestureTapCallback onTap,
    Color color,
    EdgeInsets margin,
    Widget child, {
    double? height,
  }) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: color,
          ),
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
          color: color,
        ),
      ),
    );
  }
}
