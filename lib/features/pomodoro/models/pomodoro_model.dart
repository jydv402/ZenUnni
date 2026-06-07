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
    this.rounds = 1,
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
