import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class UsernamePage extends ConsumerWidget {
  final bool? isUpdate;
  const UsernamePage({super.key, this.isUpdate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = TextEditingController();
    //TODO: define methods to check if username already exist
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          const Text(
            "What should\nwe call you?",
            style: headL,
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
        stateInvalidator(ref);
        String username = userNameController.text.trim();

        if (username.isNotEmpty && !isUpdate!) {
          await createUserDoc(username);
          if (context.mounted) {
            Navigator.pushNamed(context, '/nav');
          }
        } else if (username.isNotEmpty && isUpdate!) {
          await updateUserDoc(username);
          if (context.mounted) {
            Navigator.pop(context);
          }
        } else {
          showHeadsupNoti(context, "Please enter a username first.");
        }
      }, 'Continue', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
