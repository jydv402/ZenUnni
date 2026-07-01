import 'package:flutter/gestures.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zen/zen_barrel.dart';

class LandPage extends ConsumerWidget {
  const LandPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider).value;
    final profile = ref.watch(userProvider).value;

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
      body: homeScreen(context, ref, userName),
    );
  }

  Widget homeScreen(BuildContext context, WidgetRef ref, String? user) {
    final colors = ref.watch(appColorsProvider);
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TopBar(),
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

        const Flex(
          direction: Axis.horizontal,
          children: [ChatBentoCard(margin: EdgeInsets.fromLTRB(0, 0, 0, 8))],
        ),
        // 1st row: Mood and Mood Logs
        const Row(
          children: [
            MoodBentoCard(margin: EdgeInsets.fromLTRB(0, 0, 4, 4)),
            MoodLogsBentoCard(margin: EdgeInsets.fromLTRB(4, 0, 0, 4)),
          ],
        ),
        // Row with Schedule and Tasks
        const Row(
          children: [
            ScheduleBentoCard(margin: EdgeInsets.fromLTRB(0, 4, 4, 4)),
            TasksBentoCard(margin: EdgeInsets.fromLTRB(4, 4, 0, 4)),
          ],
        ),
        // Row with Habits and Profile
        const Row(
          children: [
            HabitsBentoCard(margin: EdgeInsets.fromLTRB(0, 4, 4, 0)),
            ProfileBentoCard(margin: EdgeInsets.fromLTRB(4, 4, 0, 0)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 26, 2),
          child: Text("Extras", style: Theme.of(context).textTheme.titleMedium),
        ),
        const Row(
          children: [
            PomodoroBentoCard(margin: EdgeInsets.fromLTRB(0, 4, 4, 0)),
            NotesBentoCard(margin: EdgeInsets.fromLTRB(4, 4, 0, 0)),
          ],
        ),
        // Footer text
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 10),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontFamily: "Pop", height: 1.1),
              children: [
                TextSpan(
                  text: "ZenUnni",

                  style: TextStyle(
                    fontFamily: "Pop",
                    fontSize: MediaQuery.sizeOf(context).width * 0.22,
                    letterSpacing: -5,
                    fontWeight: FontWeight.w600,
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
}

class BentoCard extends StatelessWidget {
  final int flex;
  final GestureTapCallback onTap;
  final Color color;
  final EdgeInsets margin;
  final Widget child;
  final double? height;

  const BentoCard({
    super.key,
    required this.flex,
    required this.onTap,
    required this.color,
    required this.margin,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
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
}

class BentoBgText extends StatelessWidget {
  final double left;
  final String label;
  final Color color;
  final double? top;

  const BentoBgText({
    super.key,
    required this.left,
    required this.label,
    required this.color,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
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

class ChatBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const ChatBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return BentoCard(
      flex: 1,
      height: 200,
      onTap: () => Navigator.pushNamed(context, "/chat"),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(
            left: -15,
            label: "Chat",
            color: colors.homeBgTxt,
            top: 25,
          ),
          Center(
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/loading/ld_shapes.json",
                  height: 80,
                  width: 80,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
                ),
                Text(
                  "Unni",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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
    );
  }
}

class MoodBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const MoodBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final mood = ref.watch(moodProvider).value;
    return BentoCard(
      flex: 3,
      onTap: () => updatePgIndex(ref, 3),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -20, label: "Mood", color: colors.homeBgTxt),
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
                          frameRate: FrameRate(30),
                          renderCache: RenderCache.raster,
                        ),
                        Text(
                          "So empty...",
                          style: Theme.of(context).textTheme.headlineMedium,
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
                          frameRate: FrameRate(30),
                          renderCache: RenderCache.raster,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Mood :\n",
                                style: Theme.of(context).textTheme.bodySmall,
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
    );
  }
}

class MoodLogsBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const MoodLogsBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return BentoCard(
      flex: 2,
      onTap: () => updatePgIndex(ref, 9),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -20, label: "Logs", color: colors.homeBgTxt),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Lottie.asset(
                    "assets/emoji/sparkle.json",
                    height: 100,
                    width: 100,
                    reverse: true,
                    frameRate: FrameRate(30),
                    renderCache: RenderCache.raster,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Mood Logs",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "View history",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const ScheduleBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return BentoCard(
      flex: 2,
      onTap: () {
        ref.read(selectedTabProvider.notifier).setTab(1);
        updatePgIndex(ref, 1);
      },
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -28, label: "Schedule", color: colors.homeBgTxt),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Lottie.asset(
                  "assets/emoji/magic.json",
                  height: 120,
                  width: 120,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
                ),
                Text(
                  "Craft a schedule",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TasksBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const TasksBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return BentoCard(
      flex: 3,
      onTap: () {
        ref.read(selectedTabProvider.notifier).setTab(0);
        updatePgIndex(ref, 1);
      },
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -15, label: "Tasks", color: colors.homeBgTxt),
          Center(
            child: Column(
              spacing: 22,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/emoji/rocket.json",
                  height: 120,
                  width: 120,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
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
    );
  }
}

class HabitsBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const HabitsBentoCard({super.key, required this.margin});

  List habitsCompleted(List<HabitModel> habits) {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    if (habits.isEmpty) {
      return ["assets/emoji/hatching.json", "No habits added yet\nAdd some!"];
    } else if (habits.every(
      (habit) =>
          habit.completedDates.containsKey(dateOnly) &&
          habit.completedDates[dateOnly]!,
    )) {
      return ["assets/emoji/hatched.json", "All habits completed"];
    } else {
      return ["assets/emoji/hatching.json", "You have habits left to complete"];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final habitDetails = ref.watch(habitProvider).value ?? [];
    final habitStatus = habitsCompleted(habitDetails);
    return BentoCard(
      flex: 1,
      onTap: () => updatePgIndex(ref, 2),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -40, label: "Habits", color: colors.homeBgTxt),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                Lottie.asset(
                  habitStatus[0],
                  height: 120,
                  width: 120,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
                ),
                const SizedBox(height: 18),
                Text(
                  habitStatus[1],
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const ProfileBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final profileDetails = ref.watch(userProvider).value;
    if (profileDetails == null) return const SizedBox.shrink();
    return BentoCard(
      flex: 1,
      onTap: () => updatePgIndex(ref, 6),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -25, label: "Profile", color: colors.homeBgTxt),
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
                      image: profileDetails.gender == 0
                          ? AssetImage(
                              males.values.elementAt(profileDetails.avatar),
                            )
                          : AssetImage(
                              females.values.elementAt(profileDetails.avatar),
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
                        style: Theme.of(context).textTheme.headlineMedium
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
    );
  }
}

class PomodoroBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const PomodoroBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return BentoCard(
      flex: 1,
      onTap: () => updatePgIndex(ref, 4),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -10, label: "Pomodoro", color: colors.homeBgTxt),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/emoji/pomo.json",
                  height: 150,
                  width: 150,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
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
    );
  }
}

class NotesBentoCard extends ConsumerWidget {
  final EdgeInsets margin;
  const NotesBentoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return BentoCard(
      flex: 1,
      onTap: () => updatePgIndex(ref, 5),
      color: colors.pillClr,
      margin: margin,
      child: Stack(
        children: [
          BentoBgText(left: -22, label: "Notes", color: colors.homeBgTxt),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                Lottie.asset(
                  "assets/emoji/note.json",
                  height: 120,
                  width: 120,
                  frameRate: FrameRate(30),
                  renderCache: RenderCache.raster,
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
    );
  }
}
