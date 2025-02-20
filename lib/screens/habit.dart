import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/habit_model.dart';
import 'package:zen/services/habit_serv.dart';
import 'package:zen/utils/color_utils.dart';

class Habit extends ConsumerStatefulWidget {
  const Habit({super.key});

  @override
  ConsumerState<Habit> createState() => _HabitState();
}

class _HabitState extends ConsumerState<Habit> {
  final TextEditingController habitNameController = TextEditingController();
  Color selectedColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    final habitsAsyncValue = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: habitsAsyncValue.when(
          data: (habits) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: heatmaplistview(habits), 
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: addnewbutton(),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget addnewbutton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))), 
                
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => newHabitDialog(context));
        },
        child: Text('track new habits'));
  }

  Widget newHabitDialog(BuildContext context) {
    List<Color> colorOptions = [
      Colors.green,
      Colors.pinkAccent,
      Colors.blue,
      Colors.yellow,
      Colors.deepPurple,
      Colors.orange,
    ];

    // Color selectedColor = Colors.green;

    return SimpleDialog(
      children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: habitNameController,
                    decoration: InputDecoration(
                        hintText: 'Enter habit name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)))),
                SizedBox(height: 30),
                Text('Choose a color'),
                SizedBox(
                  height:
                      150, //sizebox to get rid of the preset padding of block picker
                  // Todo:update this
                  child: BlockPicker(
                      pickerColor: selectedColor,
                      availableColors: colorOptions,
                      onColorChanged: (Color color) {
                        selectedColor = color;
                      }),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () async {
                      if (habitNameController.text.isNotEmpty) {
                        final newHabit = HabitModel(
                          habitName: habitNameController.text,
                          color: selectedColor.value.toRadixString(16),
                          createdAt: DateTime.now(),
                          completedDates: {},
                        );

                        await ref.read(habitAddProvider(newHabit).future);
                        habitNameController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Text('ADD'))
              ],
            ))
      ],
    );
  }

  Widget heatmaplistview(List<HabitModel> habits) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (BuildContext context, int index) {
        final habit = habits[index];
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 49, 49),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(habit.habitName,
                        style: TextStyle(fontSize: 20,color: Colors.white),),
                        IconButton(
                          onPressed: () async {
                            final today = DateTime.now();
                            final dateOnly =
                                DateTime(today.year, today.month, today.day);
                    
                            final updatedCompletedDates =
                                Map<DateTime, bool>.from(habit.completedDates);
                    
                            if (updatedCompletedDates.containsKey(dateOnly) &&
                                updatedCompletedDates[dateOnly] == true) {
                              updatedCompletedDates[dateOnly] = false;
                            } else {
                              updatedCompletedDates[dateOnly] = true;
                            }
                    
                            final updatedHabit = habit.copyWith(
                                completedDates: updatedCompletedDates);
                    
                            try {
                              await ref
                                  .read(habitUpdateProvider(updatedHabit).future);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to update habit: $e')));
                              }
                            }
                          },
                          icon: Icon(habit.completedDates.containsKey(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day)) &&
                                  habit.completedDates[DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day)]!
                              ? Icons.check_circle
                              : Icons.check),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: heatmap(habit),
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget heatmap(HabitModel habit) {
    final datasets = habit.completedDates.map((date, completed) {
      return MapEntry(
          DateTime(date.year, date.month, date.day), completed ? 1 : 0);
    });

    // Ensure color string is properly formatted with leading '0x' or '#'
    String colorString = habit.color;
    if (!colorString.startsWith('0x') && !colorString.startsWith('#')) {
      colorString = '#$colorString';
    }

    Color habitColor;
    habitColor = getColorFromHex(colorString);

    try {
      return HeatMap(
        datasets: datasets,
        endDate: DateTime.now(),
        startDate: DateTime.now().subtract(const Duration(days: 128)),
        colorMode: ColorMode.color,
        size: 14,
        showColorTip: false,
        showText: false,
        scrollable: true,
        textColor: Colors.white,
        defaultColor: const Color.fromARGB(255, 75, 75, 75),
        colorsets: {
          1: habitColor.withAlpha(255),
        },
      );
    } catch (e) {
      print("Error rendering HeatMap: $e");
      return const SizedBox();
    }
  }
}
