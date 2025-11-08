//Message class with text and isUser bool with Riverpod
import 'package:zen/zen_barrel.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

final msgProvider =
    NotifierProvider<MessageNotifier, List<Message>>(MessageNotifier.new);

class MessageNotifier extends Notifier<List<Message>> {
  @override
  List<Message> build() => [];

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
    final user = ref.watch(userProvider);
    final mood = ref.watch(moodProvider);

    final aiResponse = await AIService().chatIsolate(msg, chatMsgs,
        user.value?.username ?? '', user.value?.about ?? '', mood.value ?? '');

    return Message(
        text: aiResponse
            .replaceAll(
                RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
            .trim(),
        isUser: false);
  },
);
