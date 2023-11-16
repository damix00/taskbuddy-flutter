import 'package:flutter/material.dart';

class CreatePostTitleDesc extends StatelessWidget {
  final String title;
  final String desc;

  const CreatePostTitleDesc({Key? key, required this.title, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          desc,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

class TitleDescSmall extends StatelessWidget {
  final String title;
  final String desc;

  const TitleDescSmall({Key? key, required this.title, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Flexible(
          child: Text(
            desc,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}