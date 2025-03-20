import 'package:flutter_lucide/flutter_lucide.dart';
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
        LucideIcons.user_round,
        size: 22,
      ),
      label: 'Profile',
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
        bottomNavigationBar: NavigationBar(
          indicatorColor: Color(0xFFFF8B2C),
          surfaceTintColor: Color.fromARGB(255, 150, 150, 150),
          shadowColor: Colors.black,
          elevation: 16,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: pgIndex > 4 ? subPgIndex : pgIndex,
          destinations: destinations,
          onDestinationSelected: (int index) {
            setState(
              () {
                if (index == 2) {
                  ref.read(navStackProvider.notifier).reset(); // Reset to Home
                } else if (ref.read(navStackProvider).last != index) {
                  ref
                      .read(navStackProvider.notifier)
                      .push(index); // Add to stack
                }
                updatePgIndex(ref, index, index);
              },
            );
            print(navStack);
          },
        ),
        // floatingActionButton: pgIndex != 2
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           Navigator.pushNamed(context, '/chat');
        //         },
        //         child: const Icon(
        //           LucideIcons.message_square_dot,
        //           color: Colors.black,
        //         ),
        //       )
        //     : null,
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
