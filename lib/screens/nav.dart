import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/zen_barrel.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  List<Widget> pages = [
    const TodoListPage(),
    const SchedPage(),
    const LandPage(),
    const CurrentMood(),
    const ConnectPage(),
    const MoodPage(),
  ];

  List<Widget> destinations = [
    NavigationDestination(icon: Icon(LineIcons.tasks), label: 'Tasks'),
    NavigationDestination(icon: Icon(LineIcons.calendar), label: 'Schedule'),
    NavigationDestination(icon: Icon(LineIcons.home), label: 'Home'),
    NavigationDestination(icon: Icon(LineIcons.smilingFace), label: 'Mood'),
    NavigationDestination(icon: Icon(LineIcons.users), label: 'Connect'),
  ];

  @override
  Widget build(BuildContext context) {
    int pgIndex = ref.watch(pgIndexProvider);
    int subPgIndex = ref.watch(subPgIndexProvider);
    return Scaffold(
      body: pages[pgIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.blue.shade200,
        shadowColor: Colors.white,
        elevation: 16,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: pgIndex > 4 ? subPgIndex : pgIndex,
        destinations: destinations,
        onDestinationSelected: (int index) {
          setState(
            () {
              updatePgIndex(ref, index, index);
            },
          );
        },
      ),
      floatingActionButton: pgIndex != 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: const Icon(LineIcons.comment),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
