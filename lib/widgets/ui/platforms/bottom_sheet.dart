import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
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
    bool safeArea = true,
    String? title,
  }) {
    if (Platform.isAndroid || forceAndroidVersion) {
      showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        builder: (ctx) {
          return _AndroidBottomSheet(title: title, buttons: buttons);
        }
      );
    }

    else {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return _CupertinoBottomSheet(title: title, buttons: buttons, showCancelButton: iosShowCancelButton,);
        }
      );
    }
  }
}

class BottomSheetBase extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const BottomSheetBase({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              )
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: mainAxisSize,
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AndroidBottomSheet extends StatelessWidget {
  final List<BottomSheetButton> buttons;
  final String? title;
  final bool safeArea;

  const _AndroidBottomSheet({
    required this.buttons,
    this.title,
    this.safeArea = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      children: [
        if (title != null)
          Text(title!, style: Theme.of(context).textTheme.titleSmall),
        ...buttons.map((button) {
          return ListTile(
            leading: Icon(button.icon, color: Theme.of(context).colorScheme.onBackground),
            title: Text(button.title, style: Theme.of(context).textTheme.bodyMedium!),
            onTap: () {
              Navigator.of(context).pop(); // Close the bottom sheet
              button.onTap(context);
            },
          );
        }).toList(),
        if (safeArea)
          SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]
    );
  }
}

class _CupertinoBottomSheet extends StatelessWidget {
  final List<BottomSheetButton> buttons;
  final bool showCancelButton;
  final String? title;

  const _CupertinoBottomSheet({
    Key? key,
    required this.buttons,
    this.showCancelButton = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null ? Text(title!) : null,
      cancelButton: showCancelButton
        ? CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(); // Close the bottom sheet
            },
            child: Text(AppLocalizations.of(context)!.cancel)
        )
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
