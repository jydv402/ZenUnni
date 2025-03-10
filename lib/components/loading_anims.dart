import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context, String heading) {
  //dialog box
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(heading),
        content: Center(
          child: Lottie.asset(
            "assets/loading/ld_face.json",
            height: 100,
            width: 100,
          ),
        ),
      );
    },
  );
}
