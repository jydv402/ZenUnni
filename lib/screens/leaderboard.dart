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
    final String searchQuery = searchNameController.text.toLowerCase();
    final searchResults = ref.watch(rankedUserSearchProvider);

    return Scaffold(
      body: searchResults.when(
        data: (users) {
          final filteredUsers = users.where((user) {
            final username = user.username.toLowerCase();
            return username.contains(searchQuery);
          }).toList();

          if (filteredUsers.isEmpty) {
            return Center(
              child: Text(
                "No Users Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return searchResListView(filteredUsers);
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
              onChanged: (value) {
                setState(() {});
              },
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
                  'Leaderboard',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else if (index == users.length + 1) {
          return const SizedBox(height: 140);
        } else if (index == 1) {
          return SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                //rankCard(double top, double right, double left, String rank,String username, String score)
                //Rank 1
                rankCard(
                  0,
                  0,
                  0,
                  "1",
                  users[0].username.toString(),
                  users[0].score.toString(),
                ),
                //Rank 2
                rankCard(
                  100,
                  MediaQuery.of(context).size.width - 126,
                  26,
                  "2",
                  users[1].username.toString(),
                  users[1].score.toString(),
                ),
                //Rank 3
                rankCard(
                  100,
                  26,
                  MediaQuery.of(context).size.width - 126,
                  "3",
                  users[2].username.toString(),
                  users[2].score.toString(),
                ),
              ],
            ),
          );
        } else if (index == 2 || index == 3) {
          return const SizedBox(
            height: 72,
          );
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
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/icon/icon.png')),
                ),
              ),
              title: Text(
                "#${user.rank}           ${user.username}",
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

  Positioned rankCard(double top, double right, double left, String rank,
      String username, String score) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: Column(
        children: [
          // Text(
          //   rank,
          // ),
          Container(
            key: Key(rank),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('assets/icon/icon.png')),
            ),
            child: Text(rank),
            // child: Stack(
            //   children: [
            //     Positioned(
            //       top: 6,
            //       child: Container(
            //           decoration: BoxDecoration(

            //               shape: BoxShape.circle, color: Colors.black),
            //           child: Text(rank)),
            //     ),
            //   ],
            // ),
          ),
          Text(username),
          Text(score)
        ],
      ),
    );
  }
}
