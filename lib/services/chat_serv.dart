//Message class with text and isUser bool with Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

final msgProvider =
    StateNotifierProvider<MessageNotifier, List<Message>>((ref) {
  return MessageNotifier();
});

class MessageNotifier extends StateNotifier<List<Message>> {
  MessageNotifier() : super([]);

  void addMessage(Message message) {
    state = [...state, message];
  }
}
