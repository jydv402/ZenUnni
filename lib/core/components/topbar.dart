import 'package:zen/zen_barrel.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final user = userState.value;

    if (userState.isLoading || user == null) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final gender = user.gender;
    final avatar = user.avatar;

    return Padding(
      key: const Key('scorecard'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const OpenAppDrawerButton(),
          GestureDetector(
            onTap: () {
              updatePgIndex(ref, 6); // Profile is now index 6
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: gender == 0
                      ? AssetImage(males.values.elementAt(avatar))
                      : AssetImage(females.values.elementAt(avatar)),
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
