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
            () => updatePgIndex(ref, 5, 3),
          ),
        const SizedBox(height: 8),
        _bentos(
          context,
          1,
          () {},
          colors.pillClr,
          const EdgeInsets.fromLTRB(0, 0, 0, 8),
          Center(
            child: Text(
              "Quote",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          height: 200,
        ),
        //1st row
        Row(
          children: [
            _bentos(
              context,
              2,
              () {
                updatePgIndex(ref, 3, 3);
                ref.read(navStackProvider.notifier).push(3);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(0, 0, 4, 4),
              Center(
                child: Text(
                  'Mood',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 6, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              EdgeInsets.fromLTRB(4, 0, 0, 4),
              Center(
                child: Text(
                  "Rank",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
              Center(
                child: Text(
                  "gen sched",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
              Center(
                child: Text(
                  "No. tasks",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
              Center(
                child: Text(
                  "No. Habits",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
              Center(
                child: Text(
                  "Profile",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
              Center(
                child: Text(
                  "Pomodoro",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            _bentos(
              context,
              1,
              () {
                updatePgIndex(ref, 10, 4);
                ref.read(navStackProvider.notifier).push(4);
              },
              colors.pillClr,
              const EdgeInsets.fromLTRB(4, 4, 0, 0),
              Center(
                child: Text(
                  "Notes",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
