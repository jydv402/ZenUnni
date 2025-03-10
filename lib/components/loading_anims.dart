import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context, String heading) {
  //dialog box
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        title: Text(heading, style: Theme.of(context).textTheme.headlineMedium),
        children: [
          Center(
            child: Lottie.asset(
              "assets/loading/ld_face.json",
              height: 200,
              width: 200,
            ),
          ),
        ],
      );
    },
  );
}
