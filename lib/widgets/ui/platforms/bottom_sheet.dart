import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  static showModal(BuildContext context, List<BottomSheetButton> buttons, {
    bool iosShowCancelButton = true,
    bool forceAndroidVersion = false, // If true, will show the Android version even if on iOS
  }) {
    if (Platform.isAndroid || forceAndroidVersion) {
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
          return _CupertinoBottomSheet(buttons: buttons, showCancelButton: iosShowCancelButton,);
        }
      );
    }
  }
}

class BottomSheetBase extends StatelessWidget {
  final List<Widget> children;

  const BottomSheetBase({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            )
          ),
          ...children
        ],
      ),
    );
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
    return BottomSheetBase(
      children: buttons.map((button) {
        return ListTile(
          leading: Icon(button.icon, color: Theme.of(context).colorScheme.onBackground),
          title: Text(button.title, style: Theme.of(context).textTheme.bodyMedium!),
          onTap: () {
            Navigator.of(context).pop(); // Close the bottom sheet
            button.onTap(context);
          },
        );
      }).toList()
    );
  }
}

class _CupertinoBottomSheet extends StatelessWidget {
  final List<BottomSheetButton> buttons;
  final bool showCancelButton;

  const _CupertinoBottomSheet({
    Key? key,
    required this.buttons,
    this.showCancelButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      cancelButton: showCancelButton
        ? CupertinoActionSheetAction(onPressed: () {
          Navigator.of(context).pop(); // Close the bottom sheet
        },
      child: Text(AppLocalizations.of(context)!.cancel))
        : null,
      actions: buttons.map((button) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(); // Close the bottom sheet
            button.onTap(context);
          },
          child: Text(button.title),
        );
      },).toList(),
    );
  }
}
