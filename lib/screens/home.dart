import 'package:line_icons/line_icons.dart';
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
        if (mood == null)
          //Show add mood msg
          _msgContainer(
            context,
            "No mood added yet, add it now? 👀",
            () {
              updatePgIndex(ref, 5, 3);
              ref.read(navStackProvider.notifier).push(3);
            },
          ),
        const SizedBox(height: 8),
        _bentoBoxes(context, ref),
        const SizedBox(height: 85),
      ],
    );
  }

  GestureDetector _msgContainer(
      BuildContext context, String msg, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26), color: Colors.white30),
        child: Text(msg, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Column _bentoBoxes(BuildContext context, WidgetRef ref) {
    //Centralized variables for easy fiddling
    //defines height of the box
    const double bentoHeight = 150;
    //defines width of the box. Defaults to max occupyable space
    final double bentoWidth = MediaQuery.of(context).size.width;

    //Size of the Icon within the _bento
    const double iconSize = 135;
    //Position of the Icon within the _bento
    const double iconPos = 35;

    return Column(
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(
                context,
                () {
                  Navigator.pushNamed(context, '/chat');
                },
                Color(0xFF7F5EDF),
                bentoHeight * 2 + 8,
                bentoWidth,
                "Talk to\nUnni",
                LineIcons.sms,
                iconSize + 45,
                iconPos + 5,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                spacing: 8,
                children: [
                  _bentoBox(
                    context,
                    () {
                      updatePgIndex(ref, 3, 3);
                      ref.read(navStackProvider.notifier).push(3);
                    },
                    Color(0xFF339DF0),
                    bentoHeight,
                    bentoWidth,
                    "Mood",
                    LineIcons.beamingFaceWithSmilingEyes,
                    iconSize,
                    iconPos,
                  ),
                  _bentoBox(
                    context,
                    () {
                      updatePgIndex(ref, 0, 0);
                      ref.read(navStackProvider.notifier).push(0);
                    },
                    Color(0xFF2BBC87),
                    bentoHeight,
                    bentoWidth,
                    "Todo",
                    LineIcons.checkCircle,
                    iconSize,
                    iconPos,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(context, () {
                updatePgIndex(ref, 1, 1);
                ref.read(navStackProvider.notifier).push(1);
              }, Colors.blueAccent, bentoHeight, bentoWidth, "Habit Tracker",
                  LineIcons.peace, iconSize + 10, iconPos + 14),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(context, () {
                updatePgIndex(ref, 0, 0);
                ref.read(navStackProvider.notifier).push(0);
              }, Colors.red, bentoHeight, bentoWidth, "Schedule",
                  LineIcons.calendar, iconSize + 10, iconPos),
            ),
          ],
        ),
        //temp nav for habit tracker
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(context, () {
                updatePgIndex(ref, 7, 4);
                ref.read(navStackProvider.notifier).push(4);
              }, Colors.teal, bentoHeight, bentoWidth, "Pomodoro",
                  LineIcons.clock, iconSize + 10, iconPos),
            ),
            //temp nav for search page
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(context, () {
                updatePgIndex(ref, 6, 4);
                ref.read(navStackProvider.notifier).push(4);
              }, Colors.deepPurple, bentoHeight, bentoWidth, "Leaderboard",
                  LineIcons.users, iconSize + 10, iconPos + 4),
            ),
          ],
        )
      ],
    );
  }

  GestureDetector _bentoBox(
      BuildContext context,
      GestureTapCallback onTap,
      Color color,
      double height,
      double width,
      String label,
      IconData icon,
      double iconSize,
      double iconPos) {
    const double pos = 16;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .2),
                spreadRadius: 5,
                blurRadius: 7,
              )
            ]),
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              bottom: pos,
              left: pos,
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Positioned(
              top: -iconPos,
              left: -iconPos,
              child: Icon(
                icon,
                color: Colors.black26,
                size: iconSize,
              ),
            ),
            Positioned(
              top: pos,
              right: pos,
              child: Icon(
                Icons.arrow_outward_rounded,
                color: Colors.black,
                size: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
