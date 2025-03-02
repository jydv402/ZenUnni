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
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: userNameController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'enter a username',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),

            //to fix: if username is null then it shows previous users username?????
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    String username = userNameController.text.trim();

                    if (username.isNotEmpty) {
                      await createUserDoc(username);
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/home');
                      }
                    } else {
                      const snackBar =
                          SnackBar(content: Text('Enter a username first'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
