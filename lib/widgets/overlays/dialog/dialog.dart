import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

class DialogAction {
  final String text;
  final Function() onPressed;
  final bool isDestructiveAction;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.isDestructiveAction = false,
  });

}

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final List<DialogAction> actions;

  static void show(BuildContext context, {
    required String title,
    required String description,
    required List<DialogAction> actions,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        description: description,
        actions: actions,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      useSafeArea: false,
    );
  }

  const CustomDialog({
    required this.title,
    required this.description,
    required this.actions,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: actions.map((action) => CupertinoDialogAction(
          child: Text(action.text),
          onPressed: action.onPressed,
          isDestructiveAction: action.isDestructiveAction,
        )).toList(),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: BlurParent(
        child: Container(
        )
      )
    );
  }
}