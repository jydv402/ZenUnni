import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  final List<int> _navStack = [0];

  List<Widget> pages = [
    const LandPage(), // Home
    const TodoListPage(), // Task
    const HabitPage(), // Habit
    const CurrentMood(), // Mood
    const SchedPage(), // Schedule
    const ProfilePage(), // Profile
  ];

  List<Widget> destinations = [
    NavigationDestination(
      icon: Icon(
        LucideIcons.house,
        size: 22,
      ),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.list_check,
        size: 22,
      ),
      label: 'Tasks',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.check,
        size: 22,
      ),
      label: 'Habit',
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
        LucideIcons.clock,
        size: 22,
      ),
      label: 'Schedule',
    ),
    NavigationDestination(
      icon: Icon(
        LucideIcons.square_user_round,
        size: 22,
      ),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int pgIndex = ref.watch(pgIndexProvider);
    int subPgIndex = ref.watch(subPgIndexProvider);
    return PopScope(
      canPop: _navStack.length <= 1, // Only allow exiting when at home
      onPopInvokedWithResult: (didPop, dynamic) {
        if (!didPop && _navStack.length > 1) {
          _navStack.removeLast();
          ref.read(pgIndexProvider.notifier).state = _navStack.last;
        }
      },
      child: Scaffold(
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
                if (_navStack.isEmpty || _navStack.last != index) {
                  _navStack.add(index);
                }
                updatePgIndex(ref, index, index);
              },
            );
          },
        ),
        floatingActionButton: pgIndex != 2
            ? FloatingActionButton(
                elevation: 2,
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: const Icon(
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
