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
  late final bool isUpdate;

  @override
  void initState() {
    super.initState();
    isUpdate = widget.isUpdate ?? false;
    if (isUpdate == true) {
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
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "What should\nwe call you?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 40),
          TextField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            maxLength: 16,
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
                      color: isSelected
                          ? Color.fromRGBO(255, 140, 43, 1)
                          : Colors.transparent,
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
            !isUpdate &&
            !existingUsers.contains(username.toLowerCase())) {
          stateInvalidator(ref, true);
          if (slctdAvt == null) {
            showHeadsupNoti(context, ref, "Please pick an avatar.");
            return;
          }
          await createUserDoc(username, gender.contains(0) ? 0 : 1, slctdAvt!);
          if (context.mounted) {
            Navigator.pushNamed(context, '/desc');
          }
        } else if (username.isNotEmpty &&
            isUpdate &&
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
      }, isUpdate ? 'Update Profile' : 'Continue', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
