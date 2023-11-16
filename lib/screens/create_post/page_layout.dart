import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostPageLayout extends StatelessWidget {
  final String title;
  final Widget page;
  final Widget bottom;

  const CreatePostPageLayout({
    Key? key,
    required this.title,
    required this.page,
    required this.bottom
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              page,
              bottom
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePostContentLayout extends StatelessWidget {
  final List<Widget> children;

  const CreatePostContentLayout({
    required this.children,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
          ...children,
          const SizedBox(height: Sizing.formSpacing,),
        ]
      ),
    );
  }
}

class CreatePostBottomLayout extends StatelessWidget {
  final List<Widget> children;

  const CreatePostBottomLayout({
    required this.children,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Column(
        children: [
          ...children,
          SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding),
        ],
      ),
    );
  }
}
