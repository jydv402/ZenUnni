import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/services/gamify_serve.dart';
import 'package:zen/services/habit_serv.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/services/pomodoro_serve.dart';
import 'package:zen/services/schedule_serv.dart';
import 'package:zen/services/search_serv.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/services/user_serv.dart';

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
