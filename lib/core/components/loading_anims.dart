import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context, String heading) {
  //dialog box
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        title: Text(heading, style: Theme.of(context).textTheme.headlineMedium),
        children: [
          Center(
            child: Lottie.asset(
              "assets/loading/ld_face.json",
              height: 200,
              width: 200,
              frameRate: FrameRate(30),
              renderCache: RenderCache.raster,
            ),
          ),
        ],
      );
    },
  );
}

Column showRunningIndicator(BuildContext context, String message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Lottie.asset(
        "assets/loading/ld_shapes.json",
        height: 100,
        width: 100,
        frameRate: FrameRate(30),
        renderCache: RenderCache.raster,
      ),
      const SizedBox(height: 20),
      Text(
        message,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
