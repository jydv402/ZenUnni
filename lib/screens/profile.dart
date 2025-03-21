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
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
          child: Column(
            spacing: 16,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(26, 26, 26, 2),
          child: Text("Account", style: prfDivTxt),
        ),
        buttonBg(
          ListTile(
            title: const Text("Change username", style: bodyM),
            trailing: Icon(LucideIcons.user_round_pen),
            onTap: () {
              Navigator.push(
                context,
                //Define the isUpdate parameter as true
                MaterialPageRoute(
                  builder: (context) => const UsernamePage(
                    isUpdate: true,
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
              // show logout dialog
              showConfirmDialog(
                context,
                "Logout ?",
                "Are you sure you want to logout ?",
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
  }

  Container buttonBg(Widget child) {
    return Container(
        height: 100,
        margin: const EdgeInsets.fromLTRB(6, 3, 6, 3),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32), color: Colors.black12),
        child: child);
  }
}
