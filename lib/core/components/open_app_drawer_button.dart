import 'package:zen/zen_barrel.dart';

class OpenAppDrawerButton extends ConsumerWidget {
  const OpenAppDrawerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return GestureDetector(
      key: const Key('open_app_drawer_button'),
      onTap: () {
        final scaffoldState = ref.read(scaffoldKeyProvider).currentState;
        if (scaffoldState != null && !scaffoldState.isDrawerOpen) {
          scaffoldState.openDrawer();
        }
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: colors.pillClr,
        ),
        child: Icon(LucideIcons.chevron_right, color: colors.mdText),
      ),
    );
  }
}
