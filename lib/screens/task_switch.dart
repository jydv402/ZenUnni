import 'package:intl/intl.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';
import 'package:zen/zen_barrel.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends ConsumerState<TaskPage> {
  int _selectedTab = 0; // 0 = Todo, 1 = Schedule

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedTab == 0 ? todoListPage() : schedulePage(),
      ),
      floatingActionButton: _selectedTab == 0
          ? fabButton(context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(),
                ),
              );
            }, "Add New Tasks", 26)
          : FloatingActionButton(
              onPressed: () {},
              child: schedulePopUp(context),
            ),
      // fabButton(context, () {
      //     clearScheduleData(ref, tasks.value ?? []);
      //   }, "Regenerate Schedule", 26),
      floatingActionButtonLocation: _selectedTab == 0
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
    );
  }

  /// Custom tab switcher
  Widget _tabSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(), // Even space between tabs
        _tabButton("Todo", 0),
        const Spacer(),
        _tabButton("Schedule", 1),
        const Spacer(),
      ],
    );
  }

  /// Tab Button
  Widget _tabButton(String title, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedTab = index;
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Text(
          title,
          style: isSelected
              ? Theme.of(context).textTheme.headlineLarge
              : Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  // Todo List
  Widget todoListPage() {
    final taskList = ref.watch(taskProvider);
    return taskList.when(
      data: (tasks) => _taskListView(tasks),
      loading: () => Center(
        child: showRunningIndicator(context, "Loading Todo data..."),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error: $error',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  // Task List
  Widget _taskListView(List<TodoModel> tasks) {
    int score = 0;
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      itemCount: tasks.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScoreCard(),
                _tabSwitcher(),
              ],
            ),
          );
        } else if (index == tasks.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final task = tasks[index - 1];
          return Container(
            padding: const EdgeInsets.fromLTRB(26, 6, 10, 26),
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    task.expired
                        ? Text(
                            "Task Pending",
                            style: bodyM.copyWith(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          )
                        : Text(
                            "Task Expired",
                            style: bodyM.copyWith(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          "Delete Task ?",
                          "Are you sure you want to delete this task ?",
                          "Delete",
                          Colors.red,
                          () {
                            ref.read(taskDeleteProvider(task));
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(
                        LucideIcons.trash_2,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    //Edit Button
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskPage(taskToEdit: task),
                          ),
                        );
                      },
                      icon: Icon(
                        LucideIcons.square_pen,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    task.expired
                        ? Checkbox(
                            value: task.isDone,
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                            activeColor: Colors.white,
                            overlayColor: WidgetStatePropertyAll(Colors.white),
                            focusColor: Colors.white,
                            checkColor: Colors.black,
                            onChanged: (bool? value) {
                              final updatedTask = TodoModel(
                                name: task.name,
                                description: task.description,
                                date: task.date,
                                priority: task.priority,
                                isDone: value ?? false,
                                expired: task.expired,
                              );
                              ref.read(taskUpdateFullProvider(updatedTask));
                              if (task.priority == "High") {
                                ref.read(scoreIncrementProvider(
                                    value! ? 25 : -25)); // High priority score
                                score = 25;
                              } else if (task.priority == "Medium") {
                                ref.read(scoreIncrementProvider(value!
                                    ? 15
                                    : -15)); // Medium priority score
                                score = 15;
                              } else {
                                ref.read(scoreIncrementProvider(
                                    value! ? 10 : -10)); // Low priority score
                                score = 10;
                              }
                              if (value) {
                                showHeadsupNoti(
                                  context,
                                  ref,
                                  "Hurray! Task Completed.\n$score Points Earned",
                                );
                              } else {
                                showHeadsupNoti(
                                  context,
                                  ref,
                                  "Oops! Lost $score Points",
                                );
                              }
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Text(
                  task.name,
                  style: task.expired
                      ? Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white)
                      : Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text(
                  task.description,
                  style: task.expired
                      ? headS.copyWith(color: Colors.white)
                      : headS.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 26),
                Text(
                  "•  Due Date: ${DateFormat('dd MMM y').format(task.date)}",
                  style: task.expired
                      ? bodyS.copyWith(color: Colors.white)
                      : bodyS.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text(
                  "•  Due Time: ${DateFormat('hh:mm a').format(task.date)}",
                  style: task.expired
                      ? bodyS.copyWith(color: Colors.white)
                      : bodyS.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "•  Priority: ",
                      style: task.expired
                          ? bodyS.copyWith(color: Colors.white)
                          : bodyS.copyWith(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white,
                              decorationThickness: 2),
                    ),
                    TextSpan(
                      text: task.priority,
                      style: task.expired
                          ? bodyS.copyWith(
                              color: task.priority == "High"
                                  ? Colors.red.shade200
                                  : task.priority == "Medium"
                                      ? Colors.orange.shade200
                                      : Colors.green.shade200,
                            )
                          : bodyS.copyWith(
                              color: task.priority == "High"
                                  ? Colors.red.shade200
                                  : task.priority == "Medium"
                                      ? Colors.orange.shade200
                                      : Colors.green.shade200,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white,
                              decorationThickness: 2),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget schedulePage() {
    final tasks = ref.watch(taskProvider);
    final schedule = ref.watch(
      scheduleProvider(tasks.value ?? []),
    );
    return schedule.when(
      data: (scheduleItems) {
        return _scheduleListView(scheduleItems);
      },
      error: (error, stackTrace) => _scheduleFailListView(context),
      loading: () => Center(
        child: showRunningIndicator(context, "Generating Schedule..."),
      ),
    );
  }

  Widget _scheduleListView(List<ScheduleItem> scheduleItems) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      itemCount: scheduleItems.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScoreCard(),
                _tabSwitcher(),
              ],
            ),
          );
        } else if (index == scheduleItems.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final item = scheduleItems[index - 1];
          return scheduleCard(item);
          // return TimelineTile(
          //   alignment: TimelineAlign.manual,
          //   lineXY: 0.1,
          //   isFirst: index == 1,
          //   isLast: index == scheduleItems.length,
          //   indicatorStyle: IndicatorStyle(
          //     width: 40,
          //     height: item.duration.toDouble(),
          //     indicator: Container(
          //       height: item.duration.toDouble(),
          //       decoration: BoxDecoration(
          //         color: colors.pillClr,
          //         shape: BoxShape.circle,
          //       ),
          //       child: Icon(LucideIcons.check),
          //     ),
          //     padding: const EdgeInsets.all(6),
          //   ),
          //   beforeLineStyle: const LineStyle(
          //     color: Color.fromRGBO(255, 139, 44, 1),
          //     thickness: 3,
          //   ),
          //   afterLineStyle: const LineStyle(
          //     color: Color.fromRGBO(255, 139, 44, 1),
          //     thickness: 3,
          //   ),
          //   endChild: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 12),
          //     child: Row(
          //       children: [
          //         Text(
          //           DateFormat('hh:mm a').format(item.startTime),
          //           style: TextStyle(color: Colors.white54, fontSize: 14),
          //         ),
          //         SizedBox(width: 20),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               item.taskName,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //             Text(
          //               "${item.duration} min",
          //               style: TextStyle(color: Colors.white, fontSize: 14),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),

          // );
        }
      },
    );
  }

  Widget scheduleCard(ScheduleItem item) {
    final colors = ref.watch(appColorsProvider);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Positioned(
          top: 26,
          left: 16,
          child: Text(
            DateFormat('hh:mm a').format(item.startTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(90, 16, 26, 16),
          height: item.duration.toDouble() * 1.5,
          width: 40,
          decoration: BoxDecoration(
            color: colors.pillClr,
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        Positioned(
          bottom: 26,
          left: 16,
          child: Text(
            DateFormat('hh:mm a').format(item.endTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Positioned(
          top: item.duration.toDouble() * 0.75,
          left: 26,
          child: Text(
            '${item.duration ~/ 60} hrs\n${item.duration % 60 > 0 ? '${item.duration % 60} min' : ''}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: 22,
          left: 146,
          child: Text(
            DateFormat('dd MMM yyyy').format(item.startTime),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Positioned(
          top: item.duration.toDouble() * 0.75 - 8,
          left: 146,
          child: Text(
            item.taskName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        )
      ],
    );
  }

  Widget _scheduleFailListView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: pagePaddingWithScore,
      children: [
        const ScoreCard(),
        _tabSwitcher(),
        const SizedBox(height: 75),
        Text(
            "Oops! I couldn't generate a schedule for you.\nTry again later. 😵",
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(
            "Psst! Checking your \ninternet connection may help...🙂.\nOr is your Task list empty..?🙄",
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget schedulePopUp(BuildContext context) {
    return PopupMenuButton<int>(
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
        reverseCurve: Curves.easeInOut,
        reverseDuration: Duration(milliseconds: 200),
      ),
      offset: const Offset(-60, -130),
      icon: Icon(LucideIcons.plus),
      itemBuilder: (context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: menuItem(
            context,
            ref,
            "Edit Available Time",
            LucideIcons.pen,
            () {},
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: menuItem(
            context,
            ref,
            "Edit Schedule",
            LucideIcons.pencil,
            () {},
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: menuItem(
            context,
            ref,
            "Regenerate Schedule",
            LucideIcons.refresh_ccw,
            () {},
          ),
        ),
      ],
    );
  }
}
