import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/zen_barrel.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void logoutUser(BuildContext context, WidgetRef ref) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text("User not found"));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScoreCard(),
                  const Text(
                    "Profile",
                    style: headL,
                  ),
                ],
              ),
            ),

            // User Avatar
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: user.gender == 0
                      ? AssetImage(
                          males.values.elementAt(user.avatar),
                        )
                      : AssetImage(
                          females.values.elementAt(user.avatar),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user.username,
              style: headL,
              textAlign: TextAlign.center,
            ),

            // const SizedBox(height: 10),

            // Text(
            //   user.gender == 0 ? "Male" : "Female",
            //   style: Theme.of(context).textTheme.bodyMedium,
            //   textAlign: TextAlign.center,
            // ),

            const SizedBox(height: 26),

            // Account Settings
            const Padding(
              padding: EdgeInsets.fromLTRB(26, 26, 26, 2),
              child: Text("Account", style: prfDivTxt),
            ),
            buttonBg(
              ListTile(
                title: const Text("Change account details", style: bodyM),
                trailing: Icon(LucideIcons.user_round_pen),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsernamePage(
                        isUpdate: true,
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
            buttonBg(
              ListTile(
                title: const Text("Logout", style: bodyM),
                trailing: Icon(LucideIcons.log_out),
                onTap: () {
                  showConfirmDialog(
                    context,
                    "Logout?",
                    "Are you sure you want to logout?",
                    "Logout",
                    Colors.red,
                    () {
                      Navigator.of(context).pop();
                      logoutUser(context, ref);
                    },
                  );
                },
              ),
            ),

            // Theme Toggle
            const Padding(
              padding: EdgeInsets.fromLTRB(26, 26, 26, 2),
              child: Text("Theme", style: prfDivTxt),
            ),
            buttonBg(
              SwitchListTile(
                title: const Text("Dark Mode", style: bodyM),
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
    );
  }

  Container buttonBg(Widget child) {
    return Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 3),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black12,
      ),
      child: child,
    );
  }
}
