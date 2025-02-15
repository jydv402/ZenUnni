// lib/services/pomodoro_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroState {
  final int duration;
  final int breakDuration;
  final int rounds;
  final int currentRound;
  bool isRunning;
  int timeRemaining;
  bool isBreak;

  PomodoroState({
    this.duration = 25,
    this.breakDuration = 5,
    this.rounds = 4,
    this.currentRound = 1,
    this.isRunning = false,
    this.timeRemaining = 25 * 60,
    this.isBreak = false,
  });

  PomodoroState copyWith({
    int? duration,
    int? breakDuration,
    int? rounds,
    int? currentRound,
    bool? isRunning,
    int? timeRemaining,
    bool? isBreak,
  }) {
    return PomodoroState(
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      isRunning: isRunning ?? this.isRunning,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isBreak: isBreak ?? this.isBreak,
    );
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  Timer? _timer;

  PomodoroNotifier() : super(PomodoroState());

  void setTimer(int duration, int breakDuration, int rounds) {
    state = state.copyWith(
        // Update state immutably
        duration: duration,
        breakDuration: breakDuration,
        rounds: rounds,
        timeRemaining: duration * 60, //Convert to seconds
        currentRound: 1,
        isBreak: false,
        isRunning: false);
    _timer?.cancel();
  }

  void startTimer() {
    state = state.copyWith(isRunning: true); // Update isRunning state
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        _switchSession(); //switch between focus and break
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false); //set to timer not running
  }

  void _switchSession() {
    // Check if it was a break
    if (state.isBreak) {
      // Check if more rounds left
      if (state.currentRound < state.rounds) {
        //Change state to the next round
        state = state.copyWith(
            isBreak: false,
            timeRemaining: state.duration * 60,
            currentRound: state.currentRound + 1);
      } else {
        stopTimer(); // All rounds complete
      }
    } else {
      state = state.copyWith(
          isBreak: true, timeRemaining: state.breakDuration * 60);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomoProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>(
  (ref) => PomodoroNotifier(),
);
