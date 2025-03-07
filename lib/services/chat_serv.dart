//Message class with text and isUser bool with Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/ai_serv.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/services/user_serv.dart';

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

  void clearMessages() {
    state = [];
  }
}

final aiResponseAdder = FutureProvider.family<Message, String>(
  (ref, msg) async {
    final chatMsgs = ref.watch(msgProvider);
    final userName = ref.watch(userNameProvider);
    final mood = ref.watch(moodProvider);

    final aiResponse = await AIService()
        .chatIsolate(msg, chatMsgs, userName.value ?? '', mood.value ?? '');

    return Message(
        text: aiResponse
            .replaceAll(
                RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
            .trim(),
        isUser: false);
  },
);
