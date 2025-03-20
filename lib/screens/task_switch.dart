import 'package:zen/zen_barrel.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _selectedTab = 0; // 0 = Todo, 1 = Schedule

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50), // Adjust top spacing
          _tabSwitcher(), // Custom tab switcher
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _selectedTab == 0 ? const TodoListPage() : const SchedPage(),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom tab switcher
  Widget _tabSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("Todo", 0),
        const SizedBox(width: 20), // Space between tabs
        _tabButton("Schedule", 1),
      ],
    );
  }

  /// Tab Button
  Widget _tabButton(String title, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            fontSize: isSelected ? 24 : 18, // Larger when selected
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey, // Highlight color
          ),
        ),
      ),
    );
  }
}
