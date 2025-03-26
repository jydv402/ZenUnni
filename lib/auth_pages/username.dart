import 'package:zen/zen_barrel.dart';

class UsernamePage extends ConsumerStatefulWidget {
  final bool? isUpdate;
  final UserModel? user;
  const UsernamePage({super.key, this.isUpdate, this.user});

  @override
  ConsumerState<UsernamePage> createState() => _UsernamePageState();
}

final TextEditingController userNameController = TextEditingController();
Set<int> gender = {0};
int? slctdAvt;

class _UsernamePageState extends ConsumerState<UsernamePage> {
  @override
  void initState() {
    super.initState();
    if (widget.isUpdate == true) {
      userNameController.text = widget.user?.username ?? '';
      gender = {widget.user?.gender ?? 0};
      slctdAvt = widget.user?.avatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userNameProvider);

    //Get all the existing users
    final existingUsers = List.from(
      ref.watch(existingUsersProvider).value ?? [],
    );

    // Remove the username from existing users
    existingUsers.removeWhere(
      (user) => user.toString().toLowerCase() == username.value?.toLowerCase(),
    );

    //print(existingUsers);

    final avatars = gender.contains(0) ? males : females;
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "What should\nwe call you?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 40),
          TextField(
            maxLength: 10,
            controller: userNameController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 30),

          // Gender Selector
          SegmentedButton<int>(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
              ),
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.bodySmall,
              ),
            ),
            showSelectedIcon: false,
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
            segments: const [
              ButtonSegment(value: 0, label: Text('Male')),
              ButtonSegment(value: 1, label: Text('Female')),
            ],
            selected: gender,
            onSelectionChanged: (Set<int> value) {
              setState(
                () {
                  gender = value;
                  slctdAvt = null; // Reset avatar selection when gender changes
                },
              );
            },
          ),

          const SizedBox(height: 30),

          // Avatar Grid
          Text(
            "Pick an Avatar",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final isSelected = slctdAvt == index;
              return GestureDetector(
                onTap: () {
                  setState(
                    () {
                      slctdAvt = index;
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color:
                          isSelected ? Color(0XFFFF8C2B) : Colors.transparent,
                      width: 5,
                    ),
                  ),
                  child: Image.asset(avatars[index]!),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: fabButton(context, () async {
        String username = userNameController.text.trim();

        if (username.isNotEmpty &&
            !widget.isUpdate! &&
            !existingUsers.contains(username.toLowerCase())) {
          stateInvalidator(ref, true);
          await createUserDoc(username, gender.contains(0) ? 0 : 1, slctdAvt!);
          if (context.mounted) {
            Navigator.pushNamed(context, '/desc');
          }
        } else if (username.isNotEmpty &&
            widget.isUpdate! &&
            !existingUsers.contains(username.toLowerCase())) {
          stateInvalidator(ref, false);
          await updateUserDoc(username, gender.contains(0) ? 0 : 1, slctdAvt!);
          if (context.mounted) {
            Navigator.pop(context);
            showHeadsupNoti(context, ref, "Profile updated successfully.");
          }
        } else if (existingUsers.contains(username.toLowerCase())) {
          showHeadsupNoti(context, ref, "Username already exists.");
        } else {
          showHeadsupNoti(context, ref, "Please enter a username.");
        }
      }, widget.isUpdate! ? 'Update Profile' : 'Continue', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
