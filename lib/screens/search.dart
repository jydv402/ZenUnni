import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/search_model.dart';
import 'package:zen/services/search_serv.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchPage> {
  final searchNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String searchQuery = searchNameController.text;
    final searchResults = ref.watch(userSearchProvider(searchQuery));

    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            searchTextField(),
            SizedBox(height: 40),
            searchResults.when(
                data: (users) {
                  if (users.isEmpty) {
                    return Center(
                        child: Text(
                      "No Users Found",
                      style: TextStyle(color: Colors.white),
                    ));
                  }
                  return searchResListView(users);
                },
                error: (err, stack) => Center(child: Text("Error:$err")),
                loading: () => Center(child: CircularProgressIndicator()))
          ],
        ),
      )),
    );
  }

  Widget searchTextField() {
    return TextField(
        controller: searchNameController,
        onChanged: (value) => setState(() {}),
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.search_rounded, color: Colors.white),
            hintText: 'enter a username',
            hintStyle: TextStyle(color: Colors.white54),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10))));
  }

  Widget searchResListView(List<SearchModel> users) {
    return Expanded(
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            Color tileColor;
            if (index == 0) {
              // TODO: fill colours later
              tileColor = Colors.deepPurple.shade400; // First position colour
            } else if (index == 1) {
              tileColor = Colors.deepPurple.shade400; // Second position colour
            } else if (index == 2) {
              tileColor = Colors.deepPurple.shade400; // Third position colour
            } else {
              tileColor = Colors.deepPurple.shade400; // Other positions colour
            }
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                minVerticalPadding: 25,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: tileColor,
                leading: Text('# ${index + 1}',
                    style: TextStyle(color: Colors.black)),
                title:
                    Text(user.username, style: TextStyle(color: Colors.black)),
                trailing: Text('Score: ${user.score}',
                    style: TextStyle(color: Colors.black)),
              ),
            );
          }),
    );
  }
}
