import 'package:zen/zen_barrel.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  List<Widget> pages = [
    const TaskPage(), // index 0: Todo and Schedule
    const HabitPage(), // index 1: Habit
    const LandPage(), // index 2: Home
    const CurrentMood(), // index 3: Mood
    const ProfilePage(), // index 4: Profile
    const MoodPage(), // index 5: Add mood
    const ConnectPage(), // index 6: Leaderboard
    const PomodoroPage(), // index 7: Pomodoro
    const AddTaskPage(), // index 8: Add task
    const NotesList(), // index 9: Notes list
  ];

  List<Widget> destinations = [
    NavigationDestination(
      icon: Icon(
        LucideIcons.pencil_ruler,
        size: 22,
      ),
      label: 'Tasks',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.grid_2x2_check,
        size: 22,
      ),
      label: 'Habit',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.house,
        size: 22,
      ),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.smile,
        size: 22,
      ),
      label: 'Mood',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.ellipsis,
        size: 22,
      ),
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int pgIndex = ref.watch(pgIndexProvider);
    int subPgIndex = ref.watch(subPgIndexProvider);
    List<int> navStack = ref.watch(navStackProvider);

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return PopScope(
      canPop: navStack.length <= 1, // Only allow exiting when at home
      onPopInvokedWithResult: (didPop, dynamic) {
        if (!didPop && ref.read(navStackProvider).length > 1) {
          //Pop last element
          ref.read(navStackProvider.notifier).pop();
          //Update nav index
          ref.read(pgIndexProvider.notifier).state =
              ref.read(navStackProvider).last;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(index: pgIndex, children: pages),
        bottomNavigationBar: isKeyboardOpen
            ? null
            : NavigationBar(
                indicatorColor: const Color.fromRGBO(255, 139, 44, 1),
                surfaceTintColor: Color.fromARGB(255, 150, 150, 150),
                shadowColor: Colors.black,
                elevation: 16,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: pgIndex > 4 ? subPgIndex : pgIndex,
                destinations: destinations,
                onDestinationSelected: (int index) {
                  setState(
                    () {
                      if (ref.read(navStackProvider).last != index &&
                          index != 2) {
                        ref.read(navStackProvider.notifier).push(index);
                      } else {
                        ref.read(navStackProvider.notifier).reset();
                      }
                      updatePgIndex(ref, index, index);
                    },
                  );
                },
              ),
        floatingActionButton: pgIndex == 2
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                label: const Text(
                  ' Unni',
                  style: TextStyle(
                    fontFamily: 'Pop',
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),
                icon: const Icon(
                  LucideIcons.message_square_dot,
                  color: Colors.black,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
