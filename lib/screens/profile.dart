import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/zen_barrel.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

void logoutUser(BuildContext context, WidgetRef ref) async {
  await FirebaseAuth.instance.signOut();
  if (context.mounted) {
    // Navigate to the root page after logging out
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);
    final colors = ref.watch(appColorsProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    const div16 = SizedBox(height: 16);
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
                  Text(
                    "Profile",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),

            div16,

            // User Avatar
            Container(
              height: 150,
              width: 150,
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

            div16,

            Text(
              user.username,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),

            // const SizedBox(height: 10),

            // Text(
            //   user.gender == 0 ? "Male" : "Female",
            //   style: Theme.of(context).textTheme.Theme.of(context).textTheme.bodyMediumedium,
            //   textAlign: TextAlign.center,
            // ),

            div16,

            // Account Settings
            _divTxt("Account"),
            buttonBg(
              ListTile(
                title: Text("Change account details",
                    style: Theme.of(context).textTheme.bodyMedium),
                trailing: Icon(
                  LucideIcons.user_round_pen,
                  color: colors.iconClr,
                ),
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
                title: Text("Logout",
                    style: Theme.of(context).textTheme.bodyMedium),
                trailing: Icon(
                  LucideIcons.log_out,
                  color: colors.iconClr,
                ),
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
                      stateInvalidator(ref, true);
                    },
                  );
                },
              ),
            ),

            // Theme Toggle
            _divTxt("Theme"),
            buttonBg(
              SwitchListTile(
                title: Text("Dark Mode",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
        );
      },
      loading: () => Center(
        child: showRunningIndicator(
          context,
          "Getting your profile...",
        ),
      ),
      error: (err, _) => Center(child: Text("Error: $err")),
    );
  }

  Container buttonBg(Widget child) {
    final colors = ref.watch(appColorsProvider);
    return Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 3),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: colors.pillClr,
      ),
      child: child,
    );
  }

  Padding _divTxt(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(26, 20, 26, 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
