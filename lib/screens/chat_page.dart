import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/components/confirm_box.dart';
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 150),
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
                          ? Colors.green.shade200 //User msg pill
                          : Colors.blue.shade200, //AI msg pill
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
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: MarkdownBody(
                      data: msg.text,
                      styleSheet: markdownStyleSheetBlack,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          fabField(context, ref, controller, scrollCntrl, chatMsgs.isEmpty),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabField(
      BuildContext context,
      WidgetRef ref,
      TextEditingController controller,
      ScrollController scrollCntrl,
      bool isEmpty) {
    final MenuController menucontroller = MenuController();
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
                hintStyle: Theme.of(context).textTheme.labelMedium,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          MenuAnchor(
            controller: menucontroller,
            alignmentOffset: Offset(-10, 18),
            style: MenuStyle(
              shadowColor: WidgetStateProperty.all(Colors.white),
              alignment: Alignment(-5.5, 16),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
            ),
            builder: (context, controller, child) {
              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
                icon: Icon(
                  LineIcons.verticalEllipsis,
                  size: 26,
                ),
              );
            },
            menuChildren: [
              //Clear chat item
              if (!isEmpty)
                menuItem(context, ref, "Clear Chat", LineIcons.eraser, () {
                  showConfirmDialog(context, "Clear Chat ?",
                      "Are you sure you want to clear the chat ?", "Clear", () {
                    ref.read(msgProvider.notifier).clearMessages();
                    Navigator.of(context).pop();
                  });
                  menucontroller.close();
                }),
              //Generate schedule item
              menuItem(context, ref, "Generate Schedule", LineIcons.penSquare,
                  () {
                menucontroller.close();
              }),
            ],
          ),
          IconButton(
              padding: EdgeInsets.zero,
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
              icon: Icon(
                LineIcons.share,
                size: 26,
              )),
        ],
      ),
    );
  }
}

//Menu Item in the popup menu
ListTile menuItem(BuildContext context, WidgetRef ref, String label,
    IconData icon, GestureTapCallback onTap) {
  return ListTile(
    title: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall,
    ),
    leading: Icon(icon),
    onTap: onTap,
  );
}
