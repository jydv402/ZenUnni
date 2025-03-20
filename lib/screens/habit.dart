import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';

import 'package:zen/zen_barrel.dart';

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
        loading: () => Center(
          child: showRunningIndicator(context, "Loading Habit data..."),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: fabButton(context, () {
        habitNameController.clear();
        selectedColor = Colors.pink.shade100;
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              newHabitDialog(context, false, null),
        );
      }, 'Track new Habit', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget newHabitDialog(BuildContext context, bool isEdit, HabitModel? habit) {
    List<Color> colorOptions = [
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade200,
      Colors.green.shade200,
      Colors.orange.shade100
    ];

    // Color selectedColor = Colors.green;

    //Function to update the values
    if (isEdit) {
      habitNameController.text = habit!.habitName;
      selectedColor = getColorFromHex(habit.color);
    }

    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 26, horizontal: 26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEdit ? 'Edit Habit' : 'Add Habit',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
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
                },
              ),
            ),
            SizedBox(height: 8),
            fabButton(context, () async {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              if (habitNameController.text.isNotEmpty) {
                final newHabit = HabitModel(
                  habitName: habitNameController.text,
                  color: selectedColor
                      .toARGB32()
                      .toRadixString(16)
                      .padLeft(8, '0'),
                  createdAt: isEdit ? habit!.createdAt : DateTime.now(),
                  completedDates: isEdit ? habit!.completedDates : {},
                  oldname: isEdit ? habit!.habitName : habitNameController.text,
                );
                //Adding to firestore
                if (isEdit) {
                  //update
                  await ref.read(habitNameUpdateProvider(newHabit).future);
                } else {
                  //add new
                  await ref.read(habitAddProvider(newHabit).future);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                showHeadsupNoti(context, "Please enter a habit name.");
              }
            }, isEdit ? 'Update Habit' : 'Add Habit', 0),
          ],
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
                const Text(
                  'Habits',
                  style: headL,
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
                        habit.habitName.length > 16
                            ? '${habit.habitName.substring(0, 16)}...'
                            : habit.habitName,
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
                        showDialog(
                          context: context,
                          builder: (context) =>
                              newHabitDialog(context, true, habit),
                        );
                      },
                      icon: Icon(
                        LineIcons.pen,
                        color: habitColor,
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
                          //Habit unchecked
                          //Increment score
                          ref.read(
                            scoreIncrementProvider(-10),
                          );
                          //Show heads up
                          showHeadsupNoti(
                            context,
                            "Oops! You missed a habit.\n10 points deducted.",
                          );
                          updatedCompletedDates[dateOnly] = false;
                        } else {
                          //Habit completed
                          //Increment score
                          ref.read(
                            scoreIncrementProvider(10),
                          );
                          //Show heads up
                          showHeadsupNoti(
                            context,
                            "Great job! Keep it going.\n10 points added.",
                          );
                          //Update completed dates
                          updatedCompletedDates[dateOnly] = true;
                        }
                        final updatedHabit = habit.copyWith(
                            completedDates: updatedCompletedDates);

                        try {
                          await ref
                              .read(habitUpdateProvider(updatedHabit).future);
                        } catch (e) {
                          if (context.mounted) {
                            showHeadsupNoti(
                                context, "Failed to update habit: $e");
                          }
                        }
                      },
                      icon: Icon(habit.completedDates.containsKey(
                                DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day),
                              ) &&
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
        startDate: DateTime.now().subtract(
          const Duration(days: 128),
        ),
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
          showHeadsupNoti(context, value.toString());
        },
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
