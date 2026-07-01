import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:zen/zen_barrel.dart';

class HabitPage extends ConsumerStatefulWidget {
  const HabitPage({super.key});

  @override
  ConsumerState<HabitPage> createState() => _HabitState();
}

class _HabitState extends ConsumerState<HabitPage> {
  final TextEditingController habitNameController = TextEditingController();
  Color selectedColor = Colors.green;

  @override
  void dispose() {
    habitNameController.dispose();
    super.dispose();
  }

  void _showNewHabitDialog(
    BuildContext context,
    bool isEdit,
    HabitModel? habit,
  ) {
    if (isEdit && habit != null) {
      habitNameController.text = habit.habitName;
      selectedColor = getColorFromHex(habit.color);
    } else {
      habitNameController.clear();
      selectedColor = Colors.pink.shade100;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => newHabitDialog(context, isEdit, habit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsyncValue = ref.watch(habitProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: habitsAsyncValue.when(
        data: (habits) => heatmapListView(habits),
        loading: () => Center(
          child: showRunningIndicator(context, "Loading Habit data..."),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: fabButton(
        context,
        () {
          _showNewHabitDialog(context, false, null);
        },
        'Track new Habit',
        26,
      ),
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
      Colors.orange.shade100,
    ];

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: habitNameController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(hintText: 'Enter habit name'),
            ),
            const SizedBox(height: 30),
            Text(
              'Choose a color',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: BlockPicker(
                pickerColor: selectedColor,
                availableColors: colorOptions,
                onColorChanged: (Color color) {
                  selectedColor = color;
                },
              ),
            ),
            const SizedBox(height: 8),
            fabButton(
              context,
              () async {
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
                    oldname: isEdit
                        ? habit!.habitName
                        : habitNameController.text,
                  );
                  if (isEdit) {
                    await ref.read(habitNameUpdateProvider(newHabit).future);
                  } else {
                    await ref.read(habitAddProvider(newHabit).future);
                  }
                } else {
                  showHeadsupNoti(context, ref, "Please enter a habit name.");
                }
              },
              isEdit ? 'Update Habit' : 'Add Habit',
              0,
            ),
          ],
        ),
      ],
    );
  }

  Widget heatmapListView(List<HabitModel> habits) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      itemCount: habits.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopBar(),
                Text(
                  'Habits',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        } else if (index == habits.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final habit = habits[index - 1];
          return HabitItemCard(
            habit: habit,
            onEdit: (ctx, isEdit, model) =>
                _showNewHabitDialog(ctx, isEdit, model),
          );
        }
      },
    );
  }
}

class HabitItemCard extends ConsumerWidget {
  final HabitModel habit;
  final Function(BuildContext context, bool isEdit, HabitModel? habit) onEdit;

  const HabitItemCard({super.key, required this.habit, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: habitColor),
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
                      ref.read(habitDeleteProvider(habit));
                      Navigator.pop(context);
                    },
                  );
                },
                icon: Icon(LucideIcons.trash_2, color: habitColor, size: 22),
              ),
              IconButton(
                onPressed: () {
                  onEdit(context, true, habit);
                },
                icon: Icon(LucideIcons.square_pen, size: 22, color: habitColor),
              ),
              IconButton(
                onPressed: () async {
                  final today = DateTime.now();
                  final dateOnly = DateTime(today.year, today.month, today.day);

                  final updatedCompletedDates = Map<DateTime, bool>.from(
                    habit.completedDates,
                  );

                  if (updatedCompletedDates.containsKey(dateOnly) &&
                      updatedCompletedDates[dateOnly] == true) {
                    //Habit unchecked
                    showHeadsupNoti(context, ref, "Oops! You missed a habit.");
                    updatedCompletedDates[dateOnly] = false;
                  } else {
                    //Habit completed
                    showHeadsupNoti(context, ref, "Great job! Keep it going.");
                    //Update completed dates
                    updatedCompletedDates[dateOnly] = true;
                  }
                  final updatedHabit = habit.copyWith(
                    completedDates: updatedCompletedDates,
                  );

                  try {
                    await ref.read(habitUpdateProvider(updatedHabit).future);
                  } catch (e) {
                    if (context.mounted) {
                      showHeadsupNoti(
                        context,
                        ref,
                        "Failed to update habit: $e",
                      );
                    }
                  }
                },
                icon: Icon(
                  habit.completedDates.containsKey(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          ) &&
                          habit.completedDates[DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          )]!
                      ? Icons.check
                      : Icons.check_box_outline_blank_rounded,
                ),
                color: habitColor,
              ),
            ],
          ),
          //Heatmap widget
          HabitHeatMap(habit: habit),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class HabitHeatMap extends ConsumerWidget {
  final HabitModel habit;
  const HabitHeatMap({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasets = habit.completedDates.map((date, completed) {
      return MapEntry(
        DateTime(date.year, date.month, date.day),
        completed ? 1 : 0,
      );
    });

    String colorString = habit.color;
    if (!colorString.startsWith('0x') && !colorString.startsWith('#')) {
      colorString = '#$colorString';
    }

    Color habitColor = getColorFromHex(colorString);

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
        defaultColor: Colors.grey.shade800,
        colorsets: {1: habitColor},
        onClick: (value) {
          showHeadsupNoti(
            context,
            ref,
            DateFormat('dd MMM yyyy').format(value),
          );
        },
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
