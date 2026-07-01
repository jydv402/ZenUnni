import 'package:zen/zen_barrel.dart';
import 'package:audioplayers/audioplayers.dart';

void playPomodoroEndSound() async {
  final player = AudioPlayer();
  await player.play(AssetSource('sounds/timer.mp3'));
}

class PomodoroPage extends ConsumerStatefulWidget {
  const PomodoroPage({super.key});

  @override
  ConsumerState<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends ConsumerState<PomodoroPage> {
  int _duration = 25;
  int _breakDuration = 5;
  int _rounds = 4;

  @override
  void initState() {
    super.initState();
    final pomo = ref.read(pomoProvider);
    _duration = pomo.duration;
    _breakDuration = pomo.breakDuration;
    _rounds = pomo.rounds;
  }

  @override
  Widget build(BuildContext context) {
    final pomoNotifier = ref.read(pomoProvider.notifier);
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TopBar(),
                    Text(
                      'Pomodoro',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customize your focus and break sessions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.mdText.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    _settingCard(
                      context: context,
                      label: "Focus Duration",
                      value: "$_duration",
                      valueText: "min",
                      onDecrement: () {
                        if (_duration > 5) {
                          setState(() => _duration -= 5);
                        }
                      },
                      onIncrement: () {
                        if (_duration < 120) {
                          setState(() => _duration += 5);
                        }
                      },
                      colors: colors,
                    ),
                    const SizedBox(height: 16),
                    _settingCard(
                      context: context,
                      label: "Break Duration",
                      value: "$_breakDuration",
                      valueText: "min",
                      onDecrement: () {
                        if (_breakDuration > 1) {
                          setState(() => _breakDuration -= 1);
                        }
                      },
                      onIncrement: () {
                        if (_breakDuration < 30) {
                          setState(() => _breakDuration += 1);
                        }
                      },
                      colors: colors,
                    ),
                    const SizedBox(height: 16),
                    _settingCard(
                      context: context,
                      label: "Number of Rounds",
                      value: "$_rounds",
                      valueText: _rounds == 1 ? 'round' : 'rounds',
                      onDecrement: () {
                        if (_rounds > 1) {
                          setState(() => _rounds -= 1);
                        }
                      },
                      onIncrement: () {
                        if (_rounds < 10) {
                          setState(() => _rounds += 1);
                        }
                      },
                      colors: colors,
                    ),
                    const SizedBox(height: 100), // padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: fabButton(
        context,
        () {
          pomoNotifier.setTimer(_duration, _breakDuration, _rounds);
          pomoNotifier.startTimer();
          Navigator.pushNamed(context, '/counter');
        },
        'Start Session',
        26,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _settingCard({
    required BuildContext context,
    required String label,
    required String value,
    required String valueText,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required AppColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colors.pillClr,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.mdText.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pop',
                    ),
                    children: [
                      TextSpan(
                        text: '  $valueText',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12,
            children: [
              _circularButton(
                context: context,
                icon: LucideIcons.minus,
                onPressed: onDecrement,
                colors: colors,
              ),
              _circularButton(
                context: context,
                icon: LucideIcons.plus,
                onPressed: onIncrement,
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circularButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required AppColors colors,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.mdText.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colors.mdText, size: 18),
      ),
    );
  }
}

class CountdownScreen extends ConsumerWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomo = ref.watch(pomoProvider);
    final pomoNotifier = ref.read(pomoProvider.notifier);
    final colors = ref.watch(appColorsProvider);

    // Play sound when timer reaches zero
    if (pomo.timeRemaining == 0) {
      playPomodoroEndSound();
    }

    final double totalDuration =
        (pomo.isBreak ? pomo.breakDuration : pomo.duration) * 60.0;
    final double progress = totalDuration > 0
        ? pomo.timeRemaining / totalDuration
        : 0.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const TopBar(),
              const SizedBox(height: 16),
              Text(
                pomo.isBreak ? 'Break Session' : 'Focus Session',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Round ${pomo.currentRound} of ${pomo.rounds}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.mdText.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 40),
              // Circular Progress Timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: colors.pillClr,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        pomo.isBreak
                            ? Colors.green.shade300
                            : colors.accntOrange,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    "${(pomo.timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(pomo.timeRemaining % 60).toString().padLeft(2, '0')}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pop',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                pomo.isRunning ? 'Timer Running...' : 'Timer Paused',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.mdText.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              // Interactive controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  // Reset / Stop button
                  GestureDetector(
                    onTap: () {
                      pomoNotifier.stopTimer();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.pillClr,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.square_rounded,
                        color: colors.mdText,
                        size: 18,
                      ),
                    ),
                  ),
                  // Play / Pause button
                  GestureDetector(
                    onTap: () {
                      if (pomo.isRunning) {
                        pomoNotifier.stopTimer();
                      } else {
                        pomoNotifier.startTimer();
                      }
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colors.accntOrange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.accntOrange.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        pomo.isRunning ? Icons.pause_rounded : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
