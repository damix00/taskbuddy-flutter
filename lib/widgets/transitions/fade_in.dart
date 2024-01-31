// Fade in/out page route

import 'package:flutter/material.dart';

class FadeInPageRoute<T> extends PageRoute<T> {
  FadeInPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is FadeInPageRoute ||
        nextRoute is FadeInPageRoute ||
        nextRoute is FadeInPageRoute;
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is FadeInPageRoute ||
        previousRoute is FadeInPageRoute ||
        previousRoute is FadeInPageRoute;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}