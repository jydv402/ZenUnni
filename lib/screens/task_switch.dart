import 'package:intl/intl.dart';
import 'package:zen/zen_barrel.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends ConsumerState<TaskPage> {
  int _selectedTab = 0; // 0 = Todo, 1 = Schedule

  final TextStyle taskExpiredBodyS = bodySD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  final TextStyle taskCompletedBodyS = bodySD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  final TextStyle taskExpiredHeadM = headMD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  final TextStyle taskCompletedHeadM = headMD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  final TextStyle taskExpiredHeadS = headSD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  final TextStyle taskCompletedHeadS = headSD.copyWith(
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

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
              child: schedulePopUp(context, tasks.value ?? []),
            ),
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
                    task.notExpired
                        ? task.isDone
                            ? Text(
                                "Task Completed",
                                style: bodyM.copyWith(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                              )
                            : Text(
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
                    task.notExpired
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
                                notExpired: task.notExpired,
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
                  style: !task.notExpired
                      ? taskExpiredHeadM
                      : task.isDone
                          ? taskCompletedHeadM
                          : headMD,
                ),
                const SizedBox(height: 10),
                Text(
                  task.description,
                  style: !task.notExpired
                      ? taskExpiredHeadS
                      : task.isDone
                          ? taskCompletedHeadS
                          : headSD,
                ),
                const SizedBox(height: 26),
                Text(
                  "•  Due Date: ${DateFormat('dd MMM y').format(task.date)}",
                  style: !task.notExpired
                      ? taskExpiredBodyS
                      : task.isDone
                          ? taskCompletedBodyS
                          : bodySD,
                ),
                const SizedBox(height: 10),
                Text(
                  "•  Due Time: ${DateFormat('hh:mm a').format(task.date)}",
                  style: !task.notExpired
                      ? taskExpiredBodyS
                      : task.isDone
                          ? taskCompletedBodyS
                          : bodySD,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "•  Priority: ",
                        style: !task.notExpired
                            ? taskExpiredBodyS
                            : task.isDone
                                ? taskCompletedBodyS
                                : bodySD,
                      ),
                      TextSpan(
                        text: task.priority,
                        style: !task.notExpired
                            ? taskExpiredBodyS
                            : task.isDone
                                ? taskCompletedBodyS
                                : bodySD.copyWith(
                                    color: task.priority == "High"
                                        ? Colors.red
                                        : task.priority == "Medium"
                                            ? Colors.yellow
                                            : Colors.green,
                                  ),
                      ),
                    ],
                  ),
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
      error: (error, stackTrace) => _scheduleFailListView(context, error),
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
        }
      },
    );
  }

  Widget scheduleCard(ScheduleItem item) {
    final colors = ref.watch(appColorsProvider);
    final contHt = item.duration.toDouble() * 1.5;
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.centerLeft,
      children: [
        //Start Time
        Positioned(
          top: 26,
          left: 16,
          child: Text(
            DateFormat('hh:mm a').format(item.startTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        //Timeline
        Container(
          margin: const EdgeInsets.fromLTRB(90, 16, 26, 16),
          height: contHt < 180
              ? 180
              : contHt > 600
                  ? 600
                  : contHt,
          width: 40,
          decoration: BoxDecoration(
            color: colors.pillClr,
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        //End Time
        Positioned(
          bottom: 26,
          left: 16,
          child: Text(
            DateFormat('hh:mm a').format(item.endTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        //Duration
        Positioned(
          left: 26,
          child: Text(
            item.duration ~/ 60 == 0
                ? '${item.duration % 60} mins'
                : item.duration % 60 == 0
                    ? '${item.duration ~/ 60} hrs'
                    : '${item.duration ~/ 60} hrs\n${item.duration % 60} mins',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        //Scheduled Date
        Positioned(
          top: 22,
          left: 146,
          child: Text(
            DateFormat('dd MMM yyyy').format(item.startTime),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        //Task Details
        Positioned(
          left: 146,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${item.taskName}\n',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextSpan(
                  text:
                      'Due date : ${DateFormat('dd MMM yyyy').format(item.dueDate)}\n',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: 'Priority : ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: item.priority,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: item.priority == "High"
                            ? Colors.red
                            : item.priority == "Medium"
                                ? Colors.yellow
                                : Colors.green,
                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _scheduleFailListView(BuildContext context, error) {
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
        const SizedBox(height: 10),
        Text("Error: $error", style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget schedulePopUp(BuildContext context, List<TodoModel> tasks) {
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
            () {
              clearScheduleData(ref, tasks);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
