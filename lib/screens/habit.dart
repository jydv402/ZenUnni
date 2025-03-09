import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/components/confirm_box.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/components/scorecard.dart';
import 'package:zen/models/habit_model.dart';
import 'package:zen/services/gamify_serve.dart';
import 'package:zen/services/habit_serv.dart';
import 'package:zen/utils/color_utils.dart';

class HabitPage extends ConsumerStatefulWidget {
  const HabitPage({super.key});

  @override
  ConsumerState<HabitPage> createState() => _HabitState();
}

class _HabitState extends ConsumerState<HabitPage> {
  final TextEditingController habitNameController = TextEditingController();
  Color selectedColor = Colors.green;

  //TODO:create dispose method
  //TODO: rename widgets according  to convention

  @override
  Widget build(BuildContext context) {
    final habitsAsyncValue = ref.watch(habitProvider);

    return Scaffold(
      body: habitsAsyncValue.when(
        data: (habits) => heatmaplistview(habits),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: fabButton(context, () {
        showDialog(
            context: context,
            builder: (BuildContext context) => newHabitDialog(context));
      }, 'Track new Habit', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget addnewbutton() {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.blue.shade200,
  //           foregroundColor: Colors.black,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15))),
  //       onPressed: () {
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) => newHabitDialog(context));
  //       },
  //       child: Text('track new habits'));
  // }

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
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitNameController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter habit name',
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Choose a color',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              SizedBox(
                height:
                    160, //sizebox to get rid of the preset padding of block picker
                // TODO:update this
                child: BlockPicker(
                    pickerColor: selectedColor,
                    availableColors: colorOptions,
                    onColorChanged: (Color color) {
                      selectedColor = color;
                    }),
              ),
              SizedBox(height: 8),
              fabButton(context, () async {
                if (habitNameController.text.isNotEmpty) {
                  final newHabit = HabitModel(
                    habitName: habitNameController.text,
                    color:
                        selectedColor.value.toRadixString(16).padLeft(8, '0'),
                    createdAt: DateTime.now(),
                    completedDates: {},
                  );
                  await ref.read(habitAddProvider(newHabit).future);
                  habitNameController.clear();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter habit name'),
                    ),
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }, 'Add Habit', 0),
            ],
          ),
        )
      ],
    );
  }

  Widget heatmaplistview(List<HabitModel> habits) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      itemCount: habits.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          //Top Text
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreCard(),
                Text(
                  'Habits',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        } else if (index == habits.length + 1) {
          //Bottom padding
          return const SizedBox(height: 140);
        } else {
          final habit = habits[index - 1];
          Color habitColor = getColorFromHex(habit.color);
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        habit.habitName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: habitColor),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          "Delete Habit ?",
                          "Are you sure you want to delete this habit ?",
                          "Delete",
                          Colors.red,
                          () {
                            ref.read(
                              habitDeleteProvider(habit),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(LineIcons.alternateTrash, color: habitColor),
                    ),
                    IconButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          "Mark as done ?",
                          "Are you sure you want to mark this habit as complete ?",
                          "Yes",
                          habitColor,
                          () async {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }

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
                              await ref.read(
                                  habitUpdateProvider(updatedHabit).future);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to update habit: $e')));
                              }
                            }
                            ref.read(scoreIncrementProvider(10));
                          },
                        );
                      },
                      icon: Icon(habit.completedDates.containsKey(DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day)) &&
                              habit.completedDates[DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)]!
                          ? Icons.check
                          : Icons.check_box_outline_blank_rounded),
                      color: habitColor,
                    )
                  ],
                ),
                //Heatmap widget
                heatmap(habit),
                const SizedBox(height: 6),
              ],
            ),
          );
        }
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
        startDate: DateTime.now().subtract(const Duration(days: 128)),
        endDate: DateTime.now(),
        colorMode: ColorMode.color,
        size: 13,
        fontSize: 12,
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
