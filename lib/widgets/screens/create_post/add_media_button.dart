import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class AddMediaButton extends StatelessWidget {
  final double width, height;
  final VoidCallback onPressed;

  const AddMediaButton({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Touchable(
          onTap: onPressed,
          child: DottedBorder(
            strokeWidth: 1,
            dashPattern: const [8, 8],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: Theme.of(context).colorScheme.primary,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 128,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.25),
                  )
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.75,
                    ),
                    child: Text(
                      l10n.tapToAddImage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}