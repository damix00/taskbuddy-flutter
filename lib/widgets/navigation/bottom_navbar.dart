import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class BottomNavbarItem {
  final Widget? child;
  final IconData? icon;
  final IconData? activeIcon;

  BottomNavbarItem({
    this.icon,
    this.activeIcon,
    this.child,
  });
}

class CustomBottomNavbar extends StatelessWidget {
  final List<BottomNavbarItem> items;
  final int currentIndex;
  final Function(int) onSelected;

  const CustomBottomNavbar({
    Key? key,
    required this.items,
    required this.onSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NavbarParent(
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items.map((item) {
            int index = items.indexOf(item);
      
            return Expanded(
              child: Touchable(
                onTap: () => onSelected(index),
                // Makes the full width clickable instead of just the icon
                // Flutter is just weird sometimes
                child: AbsorbPointer(
                  child: Container(
                    height: 64,
                    child: Center(
                      child: item.child ?? Icon(
                        index == currentIndex
                            ? item.activeIcon ?? item.icon
                            : item.icon,
                        color: index == currentIndex
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )
    );
  }
}

class _NavbarParent extends StatefulWidget {
  final Widget child;

  const _NavbarParent({Key? key, required this.child}) : super(key: key);

  @override
  State<_NavbarParent> createState() => _NavbarParentState();
}

class _NavbarParentState extends State<_NavbarParent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.bottom + 64,
      child: Consumer<PreferencesModel>(
        builder: (context, prefs, child) {
          var noBlurChild = Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: child,
          );

          if (!prefs.uiBlurEnabled) {
            return noBlurChild;
          }

          // assume blur is disabled
          if (child == null) {
            return noBlurChild;
          }

          return child;
        },

        // The child is with blur
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: widget.child,
            ),
          ),
        ),
      )
    );
  }
}
