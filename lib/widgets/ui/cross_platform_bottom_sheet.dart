import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetButton {
  final String title;
  final IconData icon;
  final void Function(BuildContext context) onTap;

  BottomSheetButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class CrossPlatformBottomSheet {
  static showModal(BuildContext context, List<BottomSheetButton> buttons) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        builder: (ctx) {
          return _AndroidBottomSheet(buttons: buttons);
        }
      );
    }

    else {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return _CupertinoBottomSheet(buttons: buttons);
        }
      );
    }
  }
}

class _AndroidBottomSheet extends StatelessWidget {
  final List<BottomSheetButton> buttons;

  const _AndroidBottomSheet({
    Key? key,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: buttons.map((button) {
          return ListTile(
            leading: Icon(button.icon, color: Theme.of(context).colorScheme.onBackground),
            title: Text(button.title, style: Theme.of(context).textTheme.bodyMedium!),
            onTap: () {
              button.onTap(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _CupertinoBottomSheet extends StatelessWidget {
  final List<BottomSheetButton> buttons;

  const _CupertinoBottomSheet({
    Key? key,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: buttons.map((button) {
        return CupertinoActionSheetAction(
          onPressed: () {
            button.onTap(context);
          },
          child: Text(button.title),
        );
      }).toList(),
    );
  }
}
