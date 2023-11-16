import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

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
    return BlurParent(
      height: MediaQuery.of(context).padding.bottom + 64,
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