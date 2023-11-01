import 'package:flutter/material.dart';

class DefaultProfilePicture extends StatelessWidget {
  final double size;
  final double? iconSize;

  const DefaultProfilePicture({required this.size, this.iconSize, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(size / 2)
      ),
      child: Icon(
        Icons.person_outline,
        color: Theme.of(context).colorScheme.onSurface,
        size: iconSize ?? (size - size / 4),
      ),
    );
  }
}