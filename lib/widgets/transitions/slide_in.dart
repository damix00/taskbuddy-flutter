import 'package:flutter/material.dart';

class SlideTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final begin = Offset(1, 0);
    final end = Offset(0, 0);
    final tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOutQuint));
    final parallax = Tween(begin: Offset(0, 0), end: Offset(-0.2, 0))
        .chain(CurveTween(curve: Curves.easeInOutQuint));
    final offsetAnimation = animation.drive(tween);
    final parallaxAnimation = animation.drive(parallax);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

class SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget newWidget;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  SlideRoute({
    required this.newWidget,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
  }) : super(
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return newWidget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final begin = Offset(1, 0);
            final end = Offset(0, 0);
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOutQuint));
            final parallax = Tween(begin: Offset(0, 0), end: Offset(-0.2, 0))
                .chain(CurveTween(curve: Curves.easeInOutQuint));
            final offsetAnimation = animation.drive(tween);
            final parallaxAnimation = animation.drive(parallax);

            return SlideTransition(
              position: offsetAnimation,
              child: newWidget,
            );
          },
        );

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;
}
