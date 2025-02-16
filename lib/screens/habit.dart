import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Habit extends ConsumerStatefulWidget {
  const Habit({super.key});

  @override
  ConsumerState<Habit> createState() => _HabitState();
}

class _HabitState extends ConsumerState<Habit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          heatmap(),
          addnewbutton(),
        ],
      ),
    ));
  }

  Widget addnewbutton() {
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => newHabitDialog(context));
        },
        child: Text('track new habits'));
  }

  Widget newHabitDialog(BuildContext context) {
    List<Color> colorOptions = [
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.deepPurple,
      Colors.orange,
      Colors.brown,
    ];

    Color selectedColor = Colors.black;
    final TextEditingController habitNameController = TextEditingController();
    return SimpleDialog(
      children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: habitNameController,
                    decoration: InputDecoration(hintText: 'Enter habit name',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
                    SizedBox(height:30),
                Text('Choose a color'),
                SizedBox(
                  height:
                      150, //sizebox to get rid of the preset padding of block picker
                  child: BlockPicker(
                      pickerColor: selectedColor,
                      availableColors: colorOptions,
                      onColorChanged: (Color color) {
                        selectedColor = color;
                      }),
                ),
              ],
            ))
      ],
    );
  }

  Widget heatmap() {
    return HeatMap(
      datasets: {
        DateTime(2025, 2, 16): 3,
        DateTime(2025, 2, 17): 7,
        DateTime(2025, 2, 18): 10,
        DateTime(2025, 2, 19): 13,
        DateTime(2025, 2, 23): 6,
      },
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 90)),
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      defaultColor: const Color.fromARGB(255, 226, 220, 220),
      colorsets: {
        1: Colors.red,
        3: Colors.orange,
        5: Colors.yellow,
        7: Colors.green,
        9: Colors.blue,
        11: Colors.indigo,
        13: Colors.purple,
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }
}
