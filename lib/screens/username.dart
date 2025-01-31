import 'package:flutter/material.dart';
import 'package:zen/screens/home.dart';

class Username extends StatelessWidget {
  const Username({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandPage(),
                        ),
                      );
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
