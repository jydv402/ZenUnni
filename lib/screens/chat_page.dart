import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/theme/light.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMsgs = ref.watch(msgProvider);
    final controller = TextEditingController();
    final scrollCntrl = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(msgProvider.notifier).clearMessages();
                //Show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Chat cleared'),
                  duration: Duration(milliseconds: 300),
                ));
              },
              icon: Icon(Icons.cleaning_services_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 32, 0, 150),
              controller: scrollCntrl,
              itemCount: chatMsgs.length,
              itemBuilder: (context, index) {
                final msg = chatMsgs[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Color.fromARGB(40, 0, 17, 255)
                          : Color.fromARGB(40, 255, 0, 200),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                        topLeft: msg.isUser
                            ? Radius.circular(28)
                            : Radius.circular(2),
                        topRight: msg.isUser
                            ? Radius.circular(2)
                            : Radius.circular(28),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: MarkdownBody(
                      data: msg.text,
                      styleSheet: markdownStyleSheet,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: fabField(context, ref, controller, scrollCntrl),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabField(BuildContext context, WidgetRef ref,
      TextEditingController controller, ScrollController scrollCntrl) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 5,
              blurRadius: 7)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Chat with Unni...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          IconButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  //Add the message to the state
                  final userMsg = Message(text: controller.text, isUser: true);
                  ref.read(msgProvider.notifier).addMessage(userMsg);
                  //Get the AI response
                  final aiMsg =
                      await ref.read(aiResponseAdder(controller.text).future);
                  ref.read(msgProvider.notifier).addMessage(aiMsg);
                }
                scrollCntrl.animateTo(scrollCntrl.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
                controller.clear();
              },
              icon: Icon(Icons.send_rounded))
        ],
      ),
    );
  }
}
