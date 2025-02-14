import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pomodoro {
  final int duration;
  final int breakDuration;
  final int rounds;
  final bool isRunning;

  Pomodoro copyWith({
    int? duration,
    int? breakDuration,
    int? rounds,
    bool? isRunning,
  }) {
    return Pomodoro(
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
      rounds: rounds ?? this.rounds,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Pomodoro({
    required this.duration,
    required this.breakDuration,
    required this.rounds,
    required this.isRunning,
  });
}

final pomoProvider = StateNotifierProvider<PomodoroNotifier, Pomodoro>((ref) {
  return PomodoroNotifier();
});

class PomodoroNotifier extends StateNotifier<Pomodoro> {
  PomodoroNotifier()
      : super(Pomodoro(
            duration: 0, breakDuration: 0, rounds: 0, isRunning: false));
  Timer? _timer;
  int _currentRound = 0;
  bool _isBreak = false;
  int _timeRemaining = 0;

  void setTimer(int duration, int breakDuration, int rounds) {
    state = Pomodoro(
        duration: duration,
        breakDuration: breakDuration,
        rounds: rounds,
        isRunning: false);
  }

  void startTimer() {
    if (state.isRunning) return;

    _currentRound = 0;
    _isBreak = false;
    _startPomo();
  }

  _startPomo() {
    if (_currentRound >= state.rounds) {
      stopTimer();
      return;
    }

    _timeRemaining = _isBreak ? state.breakDuration * 60 : state.duration * 60;
    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
      } else {
        _timer?.cancel();
        _isBreak = !_isBreak;
        if (!_isBreak) _currentRound++;
        _startPomo();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(
        duration: 0, breakDuration: 0, rounds: 0, isRunning: false);
  }
}
