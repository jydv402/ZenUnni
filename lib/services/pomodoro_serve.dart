// lib/services/pomodoro_notifier.dart
import 'dart:async';
import 'package:zen/zen_barrel.dart';

class PomodoroNotifier extends Notifier<PomodoroState> {
  Timer? _timer;

  @override
  PomodoroState build() => PomodoroState();

  void setTimer(int duration, int breakDuration, int rounds) {
    state = state.copyWith(
      duration: duration,
      breakDuration: breakDuration,
      rounds: rounds,
      timeRemaining: duration * 60,
      currentRound: 1,
      isBreak: false,
      isRunning: false,
    );
    _timer?.cancel();
  }

  void startTimer() {
    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        _switchSession();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = PomodoroState(); // reset state
  }

  void _switchSession() {
    if (state.isBreak) {
      if (state.currentRound < state.rounds) {
        state = state.copyWith(
          isBreak: false,
          timeRemaining: state.duration * 60,
          currentRound: state.currentRound + 1,
        );
      } else {
        stopTimer();
      }
    } else {
      state = state.copyWith(
        isBreak: true,
        timeRemaining: state.breakDuration * 60,
      );

      // Increment score
      ref.read(scoreIncrementProvider(20));
    }
  }
}

final pomoProvider = NotifierProvider<PomodoroNotifier, PomodoroState>(
  PomodoroNotifier.new,
);
