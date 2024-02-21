import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:styled_text/styled_text.dart';

class Markdown extends StatelessWidget {
  final String data;

  const Markdown({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(md.markdownToHtml(data));

    return StyledText(
      text: md.markdownToHtml(data),
      tags: {
        'h1': StyledTextTag(style: Theme.of(context).textTheme.titleSmall),
        'p': StyledTextWidgetBuilderTag(
          (context, attributes, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                child!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          },
        ),
      }
    );
  }
}
