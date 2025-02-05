import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/theme/light.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMsgs = ref.watch(msgProvider);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        decoration: gradientDeco(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatMsgs.length,
                itemBuilder: (context, index) {
                  final msg = chatMsgs[index];
                  return ListTile(
                    title: Text(msg.text),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fabField(context, ref, controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabField(
      BuildContext context, WidgetRef ref, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Write your message',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(msgProvider.notifier)
                      .addMessage(Message(text: controller.text, isUser: true));
                }
                controller.clear();
                FocusScope.of(context).unfocus();
              },
              icon: Icon(Icons.send_rounded))
        ],
      ),
    );
  }
}
