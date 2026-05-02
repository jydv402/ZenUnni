import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zen/zen_barrel.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    final key = await _storage.read(key: 'gemini_api_key');
    if (key == null || key.isEmpty) {
      if (mounted) {
        Navigator.pushNamed(context, '/api_key');
      }
    }
  }

  List<Widget> pages = [
    const LandPage(), // index 0: Home
    const TaskPage(), // index 1: Todo and Schedule
    const HabitPage(), // index 2: Habit
    const CurrentMood(), // index 3: Mood
    const PomodoroPage(), // index 4: Pomodoro
    const NotesList(), // index 5: Notes list
    const ConnectPage(), // index 6: Leaderboard
    const ProfilePage(), // index 7: Profile
    const MoodPage(), // index 8: Add mood
    const AddTaskPage(), // index 9: Add task
  ];

  void _onDrawerItemTapped(int index, WidgetRef ref) {
    updatePgIndex(ref, index);
  }

  @override
  Widget build(BuildContext context) {
    int pgIndex = ref.watch(pgIndexProvider);

    return PopScope(
      canPop: pgIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final scaffoldState = ref.read(scaffoldKeyProvider).currentState;
        if (scaffoldState?.isDrawerOpen ?? false) {
          scaffoldState?.closeDrawer();
          return;
        }
        updatePgIndex(ref, 0);
      },
      child: Scaffold(
        key: ref.watch(scaffoldKeyProvider),
        resizeToAvoidBottomInset: false,
        body: pages[pgIndex],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Text(
                  'ZenUnni',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(LucideIcons.house),
                title: const Text('Home'),
                selected: pgIndex == 0,
                onTap: () {
                  _onDrawerItemTapped(0, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.pencil_ruler),
                title: const Text('Tasks'),
                selected: pgIndex == 1,
                onTap: () {
                  _onDrawerItemTapped(1, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.grid_2x2_check),
                title: const Text('Habit'),
                selected: pgIndex == 2,
                onTap: () {
                  _onDrawerItemTapped(2, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.smile),
                title: const Text('Mood'),
                selected: pgIndex == 3,
                onTap: () {
                  _onDrawerItemTapped(3, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.timer),
                title: const Text('Pomodoro'),
                selected: pgIndex == 4,
                onTap: () {
                  _onDrawerItemTapped(4, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.sticky_note),
                title: const Text('Notes'),
                selected: pgIndex == 5,
                onTap: () {
                  _onDrawerItemTapped(5, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trophy),
                title: const Text('Leaderboard'),
                selected: pgIndex == 6,
                onTap: () {
                  _onDrawerItemTapped(6, ref);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.user),
                title: const Text('Profile'),
                selected: pgIndex == 7,
                onTap: () {
                  _onDrawerItemTapped(7, ref);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
