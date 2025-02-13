import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/providers/username_provider.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/services/user_serv.dart';

class Username extends ConsumerWidget {
  const Username({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final _userNameController = TextEditingController();

    
    return Scaffold(
      body: SafeArea(
          child: Container(
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
                controller: _userNameController,
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
                      String username = _userNameController.text.trim();
                      await createUserDoc(username);

                    //   if (username.isNotEmpty) {
                    //   
                    //   // Set the username in the Riverpod state
                    //   ref.read(usernameProvider.notifier).state = username;

                    // }
                    Navigator.pushNamed(context, '/home');
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
