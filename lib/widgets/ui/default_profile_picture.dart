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
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(size / 2)),
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: size - 8,
      ),
    );
  }
}