import 'package:flutter/material.dart';

class DefaultProfilePicture extends StatelessWidget {
  final double size;

  const DefaultProfilePicture({required this.size, Key? key}) : super(key: key);

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
        Icons.person,
        color: Theme.of(context).colorScheme.onSurface,
        size: size - size / 4,
      ),
    );
  }
}