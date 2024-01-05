import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSend;
  final VoidCallback onMorePressed;
  final TextEditingController controller;

  const ChatInput({
    Key? key,
    required this.onSend,
    required this.controller,
    required this.onMorePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Touchable(
            onTap: onMorePressed,
            child: Icon(
              Icons.add,
              size: 22,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        CustomVerticalDivider(
          color: Theme.of(context).colorScheme.outline,
          padding: 8
        ),
        // Text input
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.typeAMessage,
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Send button
        Touchable(
          onTap: () {
            onSend(controller.text);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.send,
                  size: 22,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          )
        )
      ],
    );
  }
}