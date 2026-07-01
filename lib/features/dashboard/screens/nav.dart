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
    const ProfilePage(), // index 6: Profile
    const MoodPage(), // index 7: Add mood
    const AddTaskPage(), // index 8: Add task
    const MoodHistoryPage(), // index 9: Mood logs history
  ];

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 56, 0, 16),
                child: Text(
                  'ZenUnni',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),

              zenNavListTile(
                icon: LucideIcons.house,
                pgIndex: 0,
                label: "Home",
              ),
              zenNavListTile(
                icon: LucideIcons.pencil_ruler,
                pgIndex: 1,
                label: "Tasks",
              ),
              zenNavListTile(
                icon: LucideIcons.grid_2x2_check,
                pgIndex: 2,
                label: "Habit",
              ),
              zenNavListTile(
                icon: LucideIcons.smile,
                pgIndex: 3,
                label: "Mood",
              ),
              zenNavListTile(
                icon: LucideIcons.timer,
                pgIndex: 4,
                label: "Pomodoro",
              ),
              zenNavListTile(
                icon: LucideIcons.sticky_note,
                pgIndex: 5,
                label: "Notes",
              ),
              zenNavListTile(
                icon: LucideIcons.user,
                pgIndex: 6,
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget zenNavListTile({
    required IconData icon,
    required int pgIndex,
    required String label,
  }) {
    final colors = ref.watch(appColorsProvider);
    final currentPgIndex = ref.watch(pgIndexProvider);
    bool selected = pgIndex == currentPgIndex;

    // Highlight parent tiles for sub-pages
    if (pgIndex == 3 && (currentPgIndex == 7 || currentPgIndex == 9)) {
      selected = true;
    } else if (pgIndex == 1 && currentPgIndex == 8) {
      selected = true;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 4, 0),
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        color: selected ? Color.fromRGBO(255, 139, 44, 1) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          iconColor: colors.navDrawer,
          textColor: colors.navDrawer,
          selectedColor: Colors.black,
          leading: Icon(icon),
          title: Text(label),
          selected: selected,
          onTap: () {
            updatePgIndex(ref, pgIndex);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
