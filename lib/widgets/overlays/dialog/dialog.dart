import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
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
    if (Platform.isIOS) {
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
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BlurParent(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8,),
                  Text(description, style: Theme.of(context).textTheme.bodyMedium,),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions.map((action) => Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Touchable(
                        onTap: action.onPressed,
                        child: Text(
                          action.text,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                    )).toList()
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}