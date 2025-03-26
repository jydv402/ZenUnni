import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/zen_barrel.dart';

class ChatPage extends ConsumerWidget {
  ChatPage({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMsgs = ref.watch(msgProvider);

    const msgs = {
      "Say Hi to Unni!": "Hey Unni! How's it going?",
      "Ask Unni anything": "Hey Unni, I need your help with something.",
      "Share it with Unni": "Can I share something with you?",
      "Get a motivational boost": "I could use some motivation right now.",
      "Tell me a fun fact": "Give me a cool fact I can share!",
      "Tell me a story": "Can you tell me a short, interesting story?",
      "Make me laugh": "Tell me a joke!",
      "Help me decide": "I need help making a decision.",
      "What's on your mind?": "Unni, surprise me with something fun!",
      "Give me some wisdom": "Drop some words of wisdom on me.",
      "Let’s chat!": "Unni, let’s just talk about something random.",
      "Inspire me": "Hit me with something inspiring!",
    };

    return Scaffold(
      body: chatMsgs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  Lottie.asset(
                    'assets/loading/ld_shapes.json',
                    alignment: Alignment.center,
                    height: 160,
                    width: 160,
                  ),
                  Text(
                    'Unni',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 120, color: Colors.blue.shade200, height: .8),
                  ),
                  Text(
                    'Ask me anything !',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: msgs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            ref.read(msgProvider.notifier).addMessage(
                                  Message(
                                    text: msgs.values.toList()[index],
                                    isUser: true,
                                  ),
                                );
                            final aiMsg = await ref.read(
                                aiResponseAdder(msgs.values.toList()[index])
                                    .future);
                            ref.read(msgProvider.notifier).addMessage(aiMsg);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white30,
                              ),
                            ),
                            child: Text(
                              msgs.keys.toList()[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    height: 0,
                                    color: Colors.grey.shade400,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          : ListView.builder(
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
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
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
      floatingActionButton: fabField(context, ref, chatMsgs.isEmpty),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabField(
    BuildContext context,
    WidgetRef ref,
    bool isEmpty,
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
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
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
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
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
              if (!isEmpty)
                menuItem(
                  context,
                  ref,
                  "Clear Chat",
                  LineIcons.eraser,
                  () {
                    showConfirmDialog(
                      context,
                      "Clear Chat ?",
                      "Are you sure you want to clear the chat ?",
                      "Clear",
                      Colors.red,
                      () {
                        ref.read(msgProvider.notifier).clearMessages();
                        Navigator.of(context).pop();
                      },
                    );
                    menucontroller.close();
                  },
                ),
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
            ),
          ),
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
