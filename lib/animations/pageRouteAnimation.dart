import 'package:flutter/material.dart';

class CustomPageRouteAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  const CustomPageRouteAnimation({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
