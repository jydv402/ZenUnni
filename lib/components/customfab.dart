import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/screens/profile.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
  });

  final double radius = 50.0;
  final double height = 100.0;
  final double width = 200.0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profile',
      child: GlassmorphicContainer(
        width: width,
        height: height,
        alignment: Alignment.center,
        blur: 20,
        borderRadius: radius + 10,
        border: 2,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFffffff).withValues(alpha: 0.1),
              const Color(0xFFFFFFFF).withValues(alpha: 0.05),
            ],
            stops: const [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withValues(alpha: 0.5),
            const Color(0xFFFFFFFF).withValues(alpha: 0.5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
                onPressed: () {},
                child: const Icon(LineIcons.home, size: 30)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return CustomOverlay(
                      child: ProfilePage(),
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastLinearToSlowEaseIn,
                        ),
                      ),
                      child: child,
                    );
                  },
                ));
              },
              child: const Icon(
                LineIcons.userAstronaut,
                size: 30,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CustomOverlay extends StatelessWidget {
  final Widget child;

  const CustomOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
