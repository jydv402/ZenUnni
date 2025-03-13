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
            return ListView(
              children: [
                header(),
                const SizedBox(height: 80),
                Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.black,
                    ),
                    child: Text(
                      "No users found matching \n\" $searchQuery \"",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            );
          }

          return searchQuery.isEmpty
              ? rankView(filteredUsers)
              : searchView(filteredUsers);
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

  Widget rankView(List<SearchModel> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return header();
        } else if (index == users.length + 1) {
          return const SizedBox(height: 130);
        } else if (index == 1) {
          return SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                //rankCard(double top, double right, double left, double dp, double fSize, String rank, String username, String score)
                //Rank 1
                rankCard(
                  0,
                  0,
                  0,
                  100,
                  18,
                  "1",
                  users[0].username.toString(),
                  users[0].score.toString(),
                  users[0].isUser ?? false,
                ),
                //Rank 2
                rankCard(
                  100,
                  MediaQuery.of(context).size.width - 80 - 28,
                  28,
                  80,
                  14,
                  "2",
                  users[1].username.toString(),
                  users[1].score.toString(),
                  users[1].isUser ?? false,
                ),
                //Rank 3
                rankCard(
                  100,
                  28,
                  MediaQuery.of(context).size.width - 80 - 28,
                  80,
                  14,
                  "3",
                  users[2].username.toString(),
                  users[2].score.toString(),
                  users[2].isUser ?? false,
                ),
              ],
            ),
          );
        } else if (index == 2 || index == 3) {
          return const SizedBox(
            height: 60,
          );
        } else {
          final user = users[index - 1];
          return rankListCards(user);
        }
      },
    );
  }

  Widget searchView(List<SearchModel> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return header();
        } else if (index == users.length + 1) {
          return const SizedBox(height: 130);
        } else {
          final user = users[index - 1];
          return rankListCards(user);
        }
      },
    );
  }

  Padding header() {
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
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  Positioned rankCard(double top, double right, double left, double dp,
      double fSize, String rank, String username, String score, bool isUser) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isUser ? Colors.white : Colors.transparent,
                      width: 4),
                ),
                child: Image.asset(
                  'assets/icon/avt.png',
                  height: dp,
                  width: dp,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: -12,
                left: -8,
                child: Container(
                  padding: EdgeInsets.all(fSize - 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Text(
                    rank,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: fSize,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: username,
              style: Theme.of(context).textTheme.headlineMedium,
              children: [
                TextSpan(
                  text: isUser ? '[You]' : '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            "$score pts",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Container rankListCards(user) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
            color: user.isUser ? Colors.white : Colors.transparent, width: 2),
        color: Colors.black,
      ),
      child: Stack(
        children: [
          //Rank text
          Positioned(
            top: 38,
            left: 26,
            child: Text(
              "${user.rank}",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          //User details
          Positioned(
            left: 75,
            top: 30,
            child: Row(
              spacing: 12,
              children: [
                Image.asset(
                  'assets/icon/avt.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
                Text.rich(
                  TextSpan(
                    text: "${user.username} ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 22),
                    children: [
                      TextSpan(
                        text: user.isUser ? '[You]' : '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Score
          Positioned(
            top: 40,
            right: 26,
            child: Text(
              "${user.score} pts",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
