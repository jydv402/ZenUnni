import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/services/user_serv.dart';
import 'package:zen/theme/light.dart';

class UsernamePage extends ConsumerWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = TextEditingController();
    //TODO: define methods to check if username already exist
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "What should\nwe call you?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 60),
          TextField(
            controller: userNameController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
        ],
      ),
      floatingActionButton: fabButton(context, () async {
        String username = userNameController.text.trim();

        if (username.isNotEmpty) {
          await createUserDoc(username);
          if (context.mounted) {
            Navigator.pushNamed(context, '/home');
          }
        } else {
          const snackBar = SnackBar(content: Text('Enter a username first'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }, 'Continue', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
