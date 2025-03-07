import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/components/confirm_box.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/services/schedule_serv.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/theme/light.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMsgs = ref.watch(msgProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 150),
              itemCount: chatMsgs.length,
              itemBuilder: (context, index) {
                final msg = chatMsgs[index];
                return Align(
                  key: ValueKey(msg.text),
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
                        bottomLeft: const Radius.circular(28),
                        bottomRight: const Radius.circular(28),
                        topLeft: msg.isUser
                            ? const Radius.circular(28)
                            : const Radius.circular(2),
                        topRight: msg.isUser
                            ? const Radius.circular(2)
                            : const Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      floatingActionButton: fabField(context, ref),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabField(
    BuildContext context,
    WidgetRef ref,
  ) {
    final MenuController menucontroller = MenuController();
    final TextEditingController controller = TextEditingController();
    final tasks = ref.watch(taskProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
              cursorColor: Colors.black,
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                hintText: 'Chat with Unni...',
                hintStyle: Theme.of(context).textTheme.labelMedium,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          MenuAnchor(
            controller: menucontroller,
            alignmentOffset: Offset(-10, 18),
            style: MenuStyle(
              shadowColor: WidgetStateProperty.all(Colors.white),
              alignment: const Alignment(-5.5, 16),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
            ),
            builder: (context, controller, child) {
              return IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
                icon: const Icon(
                  LineIcons.verticalEllipsis,
                  size: 26,
                ),
              );
            },
            menuChildren: [
              //Clear chat item
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
                ref.read(scheduleProvider(tasks.value ?? []).future);
                //schedGen(tasks.value ?? [], "user");
                menucontroller.close();
              }),
            ],
          ),
          IconButton(
              padding: const EdgeInsets.all(0),
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
                controller.clear();
              },
              icon: const Icon(
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
