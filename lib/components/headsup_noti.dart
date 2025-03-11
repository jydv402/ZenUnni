import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';

void showHeadsupNoti(BuildContext context, String message) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) => Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
      ),
      child: ToastCard(
        shadowColor: Colors.transparent,
        color: Colors.white,
        leading: Image.asset('assets/icon/icon_up.png', width: 20, height: 20),
        title: Text(
          message,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    ),
  ).show(context);
}
