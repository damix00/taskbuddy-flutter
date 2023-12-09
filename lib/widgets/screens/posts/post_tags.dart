import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/tag_widget.dart';

class PostTags extends StatelessWidget {
  final PostResponse post;

  const PostTags({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TagModel>(
      builder: (ctx, value, child) {
        if (value.isLoading) {
          return const CrossPlatformLoader();
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: post.tags.length + (post.isUrgent ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0 && post.isUrgent) {
                return Row(
                  children: [
                    const SizedBox(width: Sizing.horizontalPadding),
                    TagWidget(
                      transparent: true,
                      onSelect: (s) {},
                      isSelectable: false,
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Urgent',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              }

              // Check if tag id exists

              int i = 0;

              for (var tag in value.tags) {
                if (tag.id == post.tags[index - (post.isUrgent ? 1 : 0)]) {
                  return Row(
                    children: [
                      if (i == 0)
                        const SizedBox(width: Sizing.horizontalPadding),
                      TagWidget(
                        transparent: true,
                        tag: tag,
                        onSelect: (s) {},
                        isSelectable: false,
                      ),
                      const SizedBox(width: 8),
                    ],
                  );
                }
                i++;
              }

              return Container();
            }
          ),
        ); 
      }
    );
  }
}