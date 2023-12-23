import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class CustomRefresh extends StatelessWidget {
  final Widget child;
  final bool Function(ScrollNotification)? notificationPredicate;
  final Future<void> Function() onRefresh;
  final double paddingTop;

  const CustomRefresh({required this.onRefresh, required this.child, this.notificationPredicate, this.paddingTop = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      notificationPredicate: notificationPredicate ?? (notification) {
        // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
        return notification.depth == 2 || notification.depth == 0;
      },
      builder: (
        MaterialIndicatorDelegate(
          displacement: paddingTop,
          builder: (context, controller) {
            return Transform.rotate(
              angle: clampDouble(controller.value, 0, 1) * 3.14,
              child: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
            );
          },
          scrollableBuilder: (context, child, controller) {
            return Padding(
              padding: EdgeInsets.only(top: controller.value * 40 + paddingTop),
              child: child,
            );
          },
        )
      ),
      child: child,
    );
  }
}