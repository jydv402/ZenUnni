import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/user_serv.dart';
import 'package:zen/theme/light.dart';

class UsernamePage extends ConsumerWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = TextEditingController();
    //TODO: define methods to check if username already exist
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
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
        ),
      ),
    );
  }
}
