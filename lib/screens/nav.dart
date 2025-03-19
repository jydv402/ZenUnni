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
  int pgIndex = 2;

  List<Widget> pages = [
    const TodoListPage(),
    const SchedPage(),
    const LandPage(),
    const CurrentMood(),
    const ConnectPage(),
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
    return Scaffold(
      body: pages[pgIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.blue.shade200,
        shadowColor: Colors.white,
        elevation: 16,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: pgIndex,
        destinations: destinations,
        onDestinationSelected: (int index) {
          setState(
            () {
              pgIndex = index;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        child: const Icon(LineIcons.comment),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
