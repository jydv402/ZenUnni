import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class ConnectPage extends ConsumerStatefulWidget {
  const ConnectPage({super.key});

  @override
  ConsumerState<ConnectPage> createState() => _SearchState();
}

class _SearchState extends ConsumerState<ConnectPage> {
  final searchNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String searchQuery = searchNameController.text;
    final searchResults = ref.watch(
      userSearchProvider(searchQuery),
    );

    return Scaffold(
      body: searchResults.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text(
                "No Users Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return searchResListView(users);
        },
        error: (err, stack) => Center(
          child: Text("Error:$err"),
        ),
        loading: () => Center(
          child: showRunningIndicator(context, "Loading..."),
        ),
      ),
      floatingActionButton: searchTextField(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget searchTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 5,
              blurRadius: 7)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchNameController,
              maxLines: null,
              minLines: 1,
              cursorColor: Colors.black,
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                hintText: 'Enter a username',
                hintStyle: Theme.of(context).textTheme.labelMedium,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.search_rounded, color: Colors.black, size: 26),
          ),
        ],
      ),
    );
  }

  Widget searchResListView(List<SearchModel> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          //Top Text
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreCard(),
                Text(
                  'Connect',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        } else if (index == users.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final user = users[index - 1];
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
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: ListTile(
              minVerticalPadding: 25,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              tileColor: tileColor,
              leading: Text(
                '# $index',
                style: TextStyle(color: Colors.black),
              ),
              title: Text(
                user.username,
                style: TextStyle(color: Colors.black),
              ),
              trailing: Text(
                'Score: ${user.score}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
      },
    );
  }
}
