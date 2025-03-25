import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:zen/zen_barrel.dart';

void showHeadsupNoti(BuildContext context, WidgetRef ref, String message) {
  final colors = ref.watch(appColorsProvider);
  final theme = ref.watch(themeProvider);
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) => Container(
      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: colors.toastBg,
        border: Border.all(color: Color(0xFFFF8C2B)),
      ),
      child: ToastCard(
        shadowColor: Colors.transparent,
        color: colors.toastBg,
        leading: Image.asset('assets/icon/heads_${theme == ThemeMode.dark}.png',
            width: 20, height: 20),
        title: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ),
  ).show(context);
}
