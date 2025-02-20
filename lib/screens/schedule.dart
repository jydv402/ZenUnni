import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/theme/light.dart';

class SchedPage extends ConsumerWidget {
  const SchedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "Schedule",
            style: Theme.of(context).textTheme.headlineLarge,
          )
        ],
      ),
    );
  }
}
