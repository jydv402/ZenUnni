import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/user_serv.dart';

class Username extends ConsumerWidget {
  const Username({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "WHAT SHOULD WE CALL YOU ? ",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: '',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    String username = userNameController.text.trim();
                    await createUserDoc(username);
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
