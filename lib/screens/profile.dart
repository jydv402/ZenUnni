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
    final username = ref.watch(userNameProvider);
    return ListView(
      padding: pagePaddingWithScore,
      children: [
        const ScoreCard(),
        const Text(
          "Profile",
          style: headL,
        ),
        const SizedBox(
          height: 100,
        ),
        Text(
          username.value ?? 'No username',
          style: headL,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 26,
        ),
        fabButton(context, () {
          Navigator.push(
            context,
            //Define the isUpdate parameter as true
            MaterialPageRoute(
              builder: (context) => const UsernamePage(
                isUpdate: true,
              ),
            ),
          );
        }, "Change username", 0),
        const SizedBox(
          height: 26,
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32), color: Colors.black12),
          child: SwitchListTile(
            title: Text("Dark Mode", style: bodyM),
            value: false,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(
          height: 110,
        ),
        fabButton(context, () {
          // show logout dialog
          showConfirmDialog(context, "Logout ?",
              "Are you sure you want to logout ?", "Logout", Colors.red, () {
            Navigator.of(context).pop();
            logoutUser(context, ref); // Pass ref here
          });
        }, "Logout", 0),
      ],
    );
  }
}
