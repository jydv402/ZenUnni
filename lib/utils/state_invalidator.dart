import 'package:zen/zen_barrel.dart';

void stateInvalidator(WidgetRef ref) {
  // Invalidate all state providers
  ref.invalidate(userNameProvider); //user_serv.dart
  ref.invalidate(scoreProvider); //gamify_serv.dart
  ref.invalidate(moodProvider); //mood_serv.dart
  ref.invalidate(motivationalMessageProvider); //mood_serv.dart
  ref.invalidate(scheduleProvider); //schedule_serv.dart
  ref.invalidate(msgProvider); //chat_serv.dart
  ref.invalidate(taskProvider); //todo_serv.dart
  ref.invalidate(habitProvider); //habit_serv.dart
  ref.invalidate(pomoProvider); //pomodoro_serv.dart
  ref.invalidate(userSearchProvider); //search_serv.dart
}
