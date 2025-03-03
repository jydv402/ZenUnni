import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchPage> {
  final searchNameController = TextEditingController();
  @override


  
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         body: Column(
          children: [
            TextField(
              controller: searchNameController,
            )
          ],
         )
      ),
    );
  }
}
