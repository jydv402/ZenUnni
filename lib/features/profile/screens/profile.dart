import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_store/json_store.dart';
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

void deleteUser(BuildContext context, WidgetRef ref) async {
  try {
    showLoadingDialog(context, "Deleting account data...");
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      // Delete subcollections
      final subcollections = ['task', 'mood', 'habit'];
      for (final collectionName in subcollections) {
        final snapshots = await userDoc.collection(collectionName).get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      }

      // Delete user document
      await userDoc.delete();

      // Delete local data
      final jsonStore = JsonStore();
      await jsonStore.deleteItem('chat_history');
      final username = ref.read(userProvider).value?.username;
      if (username != null) {
        await jsonStore.deleteItem('notes$username');
      }

      // Delete auth user
      await user.delete();
    }

    if (context.mounted) {
      if (Navigator.canPop(context)) Navigator.pop(context); // Pop loading
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      if (Navigator.canPop(context)) Navigator.pop(context); // Pop loading
      showHeadsupNoti(context, ref, "Error: ${e.message}");
    }
  } catch (e) {
    if (context.mounted) {
      if (Navigator.canPop(context)) Navigator.pop(context); // Pop loading
      showHeadsupNoti(context, ref, "Error: $e");
    }
  }
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);
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
                  const TopBar(),
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
                      ? AssetImage(males.values.elementAt(user.avatar))
                      : AssetImage(females.values.elementAt(user.avatar)),
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

            // Theme Toggle
            _divTxt("Theme"),
            customSettingsButton(
              text: "Dark Mode",
              icon: isDarkMode ? LucideIcons.moon : LucideIcons.sun,
              onChanged: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),

            // Account Settings
            _divTxt("Account"),
            customSettingsButton(
              text: "Change account details",
              icon: LucideIcons.user_round_cog,
              isLast: false,
              onChanged: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UsernamePage(isUpdate: true, user: user),
                  ),
                );
              },
            ),

            customSettingsButton(
              text: "API Key Integration",
              icon: LucideIcons.key_round,
              isFirst: false,
              isLast: false,
              onChanged: () {
                Navigator.pushNamed(context, '/api_key');
              },
            ),
            customSettingsButton(
              text: "Edit personal details",
              icon: LucideIcons.user_round_pen,
              isFirst: false,
              isLast: false,
              onChanged: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescPage(isEdit: true, user: user),
                  ),
                );
              },
            ),
            customSettingsButton(
              text: "Logout",
              icon: LucideIcons.log_out,
              isFirst: false,
              isLast: false,
              onChanged: () {
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
            customSettingsButton(
              text: "Delete Account",
              icon: LucideIcons.trash_2,
              textColor: Colors.red,
              iconColor: Colors.red,
              isFirst: false,
              onChanged: () {
                showConfirmDialog(
                  context,
                  "Delete Account?",
                  "Are you sure you want to permanently delete your account? This cannot be undone.",
                  "Delete",
                  Colors.red,
                  () {
                    Navigator.of(context).pop();
                    deleteUser(context, ref);
                    stateInvalidator(ref, true);
                  },
                );
              },
            ),
          ],
        );
      },
      loading: () => Center(
        child: showRunningIndicator(context, "Getting your profile..."),
      ),
      error: (err, _) => Center(child: Text("Error: $err")),
    );
  }

  Widget customSettingsButton({
    required String text,
    required IconData icon,
    required VoidCallback onChanged,
    Color? textColor,
    Color? iconColor,
    bool isFirst = true,
    bool isLast = true,
  }) {
    final colors = ref.watch(appColorsProvider);
    final borderRadius = BorderRadius.only(
      topLeft: .circular(isFirst ? 24 : 6),
      topRight: .circular(isFirst ? 24 : 6),
      bottomLeft: .circular(isLast ? 24 : 6),
      bottomRight: .circular(isLast ? 24 : 6),
    );
    final padding = EdgeInsets.fromLTRB(6, isFirst ? 4 : 2, 6, isLast ? 4 : 2);

    return Padding(
      padding: padding,
      child: Material(
        color: colors.pillClr,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onChanged,
          child: Container(
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                ),
                Icon(icon, color: iconColor ?? colors.iconClr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _divTxt(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(26, 20, 26, 2),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
