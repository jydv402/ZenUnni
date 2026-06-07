//Message class with text and isUser bool with Riverpod
import 'package:zen/zen_barrel.dart';

import 'package:json_store/json_store.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(text: json['text'] as String, isUser: json['isUser'] as bool);
}

final JsonStore _jsonStore = JsonStore();
const String _chatHistoryKey = 'chat_history';

final msgProvider = NotifierProvider<MessageNotifier, List<Message>>(
  MessageNotifier.new,
);

class MessageNotifier extends Notifier<List<Message>> {
  @override
  List<Message> build() {
    _loadHistory();
    return [];
  }

  Future<void> _loadHistory() async {
    final stored = await _jsonStore.getItem(_chatHistoryKey);
    if (stored != null && stored['messages'] != null) {
      final messages = (stored['messages'] as List)
          .map((item) => Message.fromJson(item))
          .toList();
      state = messages;
    }
  }

  Future<void> _saveHistory(List<Message> messages) async {
    await _jsonStore.setItem(_chatHistoryKey, {
      'messages': messages.map((m) => m.toJson()).toList(),
    });
  }

  void addMessage(Message message) {
    state = [...state, message];
    _saveHistory(state);
  }

  void clearMessages() {
    state = [];
    _jsonStore.deleteItem(_chatHistoryKey);
  }
}

final aiResponseAdder = FutureProvider.family<Message, String>((
  ref,
  msg,
) async {
  final chatMsgs = ref.watch(msgProvider);
  final user = ref.watch(userProvider);
  final mood = ref.watch(moodProvider);

  final aiResponse = await ref
      .read(aiServiceProvider)
      .unniChat(
        msg,
        chatMsgs,
        user.value?.username ?? '',
        user.value?.about ?? '',
        mood.value ?? '',
      );

  return Message(
    text: aiResponse
        .replaceAll(
          RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'),
          '',
        )
        .trim(),
    isUser: false,
  );
});
