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
      backgroundColor: Colors.black,
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
            backgroundColor: Colors.blue.shade200,
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
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade200,
      Colors.green.shade200,
      Colors.orange.shade100
    ];

    // Color selectedColor = Colors.green;

    return SimpleDialog(
      backgroundColor: Colors.grey.shade900,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: habitNameController,
                  decoration: InputDecoration(
                      hintText: 'Enter habit name',
                      hintStyle: TextStyle(color: Colors.white54),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)))),
              SizedBox(height: 30),
              Text(
                'Choose a color',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(height: 10),
              SizedBox(
                height:
                    160, //sizebox to get rid of the preset padding of block picker
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
                        color: selectedColor.value
                            .toRadixString(16)
                            .padLeft(8, '0'),
                        createdAt: DateTime.now(),
                        completedDates: {},
                      );
                      await ref.read(habitAddProvider(newHabit).future);
                      habitNameController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enter habit name')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Text('ADD'))
            ],
          ),
        )
      ],
    );
  }

  Widget heatmaplistview(List<HabitModel> habits) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (BuildContext context, int index) {
        final habit = habits[index];
        Color habitColor = getColorFromHex(habit.color);
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: Text(
                          habit.habitName,
                          style: TextStyle(fontSize: 22, color: habitColor),
                        ),
                      ),
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
                            ? Icons.check
                            : Icons.check_box_outline_blank_rounded),
                        color: habitColor,
                      )
                    ],
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
        startDate: DateTime.now().subtract(const Duration(days: 135)),
        colorMode: ColorMode.color,
        size: 13,
        showColorTip: false,
        showText: false,
        scrollable: true,
        textColor: Colors.white,
        // defaultColor: habitColor.withAlpha(10),
        defaultColor: Colors.grey.shade800,
        colorsets: {1: habitColor},
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
