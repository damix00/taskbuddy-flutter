import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String? image;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const CustomNotification({required this.title, this.image, this.subtitle, this.backgroundColor, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Touchable(
          enableAnimation: onTap != null,
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: CachedNetworkImage(
                          imageUrl: image!,
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Icon(Icons.image),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
