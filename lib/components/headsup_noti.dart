import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:zen/theme/text_theme.dart';

void showHeadsupNoti(BuildContext context, String message) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) => Container(
      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        border: Border.all(color: Color(0xFFFF8C2B)),
      ),
      child: ToastCard(
        shadowColor: Colors.transparent,
        color: Colors.white,
        leading: Image.asset('assets/icon/icon_up.png', width: 20, height: 20),
        title: Text(
          message,
          style: labelS,
        ),
      ),
    ),
  ).show(context);
}
