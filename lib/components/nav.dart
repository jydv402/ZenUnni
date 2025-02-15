import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/screens/chat_page.dart';
import 'package:zen/screens/currmood.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/screens/pomodoro_page.dart';
import 'package:zen/screens/todo.dart';

class ZenBar extends StatefulWidget {
  const ZenBar({super.key});

  @override
  State<ZenBar> createState() => ZenBarState();
}

class ZenBarState extends State<ZenBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LandPage(),
    Todo(),
    ChatPage(),
    CurrentMood(),
    PomodoroPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: .1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[200]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  //text: 'Home',
                ),
                GButton(
                  icon: LineIcons.list,
                  //text: 'Todo',
                ),
                GButton(
                  icon: LineIcons.comment,
                  //text: 'Chat',
                ),
                GButton(
                  icon: LineIcons.smilingFace,
                  //text: 'Mood',
                ),
                GButton(
                  icon: LineIcons.clock,
                  // text: 'More',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
