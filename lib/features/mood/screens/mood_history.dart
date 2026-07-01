import 'package:zen/zen_barrel.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MoodHistoryPage extends ConsumerStatefulWidget {
  const MoodHistoryPage({super.key});

  @override
  ConsumerState<MoodHistoryPage> createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends ConsumerState<MoodHistoryPage> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodLogsAsync = ref.watch(moodLogsProvider);
    final colors = ref.watch(appColorsProvider);
    final now = DateTime.now();

    return Scaffold(
      body: moodLogsAsync.when(
        data: (logs) {
          // Map to group logs by date (date only key)
          final Map<DateTime, List<MoodLog>> moodMap = {};
          for (final log in logs) {
            final dateKey = DateTime(
              log.updatedOn.year,
              log.updatedOn.month,
              log.updatedOn.day,
            );
            moodMap.putIfAbsent(dateKey, () => []).add(log);
          }

          final int startWeekday =
              _focusedMonth.weekday; // 1 = Monday, 7 = Sunday
          final int daysInMonth = _getDaysInMonth(
            _focusedMonth.year,
            _focusedMonth.month,
          );
          final int offset = startWeekday - 1;

          final selectedDayLogs = moodMap[_selectedDate] ?? [];
          final bool isSelectedDateToday =
              _selectedDate.year == now.year &&
              _selectedDate.month == now.month &&
              _selectedDate.day == now.day;

          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
            physics: const BouncingScrollPhysics(),
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TopBar(),
                    Text(
                      "Mood Calendar",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),

              // Calendar Bento Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.pillClr,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    // Month selector row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.chevron_left),
                          color: colors.mdText,
                          onPressed: _prevMonth,
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(_focusedMonth),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.chevron_right),
                          color: colors.mdText,
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Weekday headers Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((
                        label,
                      ) {
                        return Expanded(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.mdText.withValues(alpha: 0.4),
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    // Days Grid
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: offset + daysInMonth,
                      itemBuilder: (context, index) {
                        if (index < offset) {
                          return const SizedBox();
                        }
                        final dayNumber = index - offset + 1;
                        final dayDate = DateTime(
                          _focusedMonth.year,
                          _focusedMonth.month,
                          dayNumber,
                        );
                        final bool isToday =
                            dayDate.year == now.year &&
                            dayDate.month == now.month &&
                            dayDate.day == now.day;
                        final bool isSelected =
                            dayDate.year == _selectedDate.year &&
                            dayDate.month == _selectedDate.month &&
                            dayDate.day == _selectedDate.day;
                        final bool isFuture = dayDate.isAfter(
                          DateTime(now.year, now.month, now.day),
                        );
                        final logsOnDay = moodMap[dayDate];

                        return _buildDayCell(
                          context: context,
                          dayDate: dayDate,
                          isSelected: isSelected,
                          isToday: isToday,
                          isFuture: isFuture,
                          logsOnDay: logsOnDay,
                          colors: colors,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Selected Date Logs Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 8,
                ),
                child: Text(
                  DateFormat('MMMM d, y').format(_selectedDate),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Logs Display Panel
              if (selectedDayLogs.isNotEmpty)
                ...selectedDayLogs.map((log) {
                  final timeStr = DateFormat('h:mm a').format(log.updatedOn);
                  final lottieAsset =
                      reversedMoodList[log.mood] ??
                      reversedMoodList["Neutral"]!;

                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(vertical: 52),
                    decoration: BoxDecoration(
                      color: colors.pillClr,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Lottie.asset(
                            lottieAsset,
                            height: 150,
                            width: 150,
                            frameRate: FrameRate(30),
                            renderCache: RenderCache.raster,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            log.mood,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            timeStr,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colors.mdText.withValues(alpha: 0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
              else
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: colors.pillClr,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      Lottie.asset(
                        reversedMoodList["Empty"]!,
                        height: 100,
                        width: 100,
                        frameRate: FrameRate(30),
                        renderCache: RenderCache.raster,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No mood logs found for this day.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (isSelectedDateToday)
                        fabButton(
                          context,
                          () {
                            updatePgIndex(ref, 7); // Navigate to Add Mood
                          },
                          'Track Mood Now',
                          32,
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => Center(
          child: showRunningIndicator(context, "Loading Mood logs..."),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildDayCell({
    required BuildContext context,
    required DateTime dayDate,
    required bool isSelected,
    required bool isToday,
    required bool isFuture,
    required List<MoodLog>? logsOnDay,
    required AppColors colors,
  }) {
    final bool hasLogs = logsOnDay != null && logsOnDay.isNotEmpty;

    return GestureDetector(
      onTap: isFuture
          ? null
          : () {
              setState(() {
                _selectedDate = dayDate;
              });
            },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? colors.accntOrange
              : (isToday ? colors.pillClr : Colors.transparent),
          border: isToday && !isSelected
              ? Border.all(
                  color: colors.accntOrange.withValues(alpha: 0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              dayDate.day.toString(),
              style: TextStyle(
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : (isFuture
                          ? colors.mdText.withValues(alpha: 0.25)
                          : colors.mdText),
              ),
            ),
            if (hasLogs && !isSelected)
              Positioned(
                bottom: 6,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.accntOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
