import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostPrice extends StatelessWidget {
  final PostResultsResponse post;

  const PostPrice({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Text(
              '€${post.price}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              ),
            ),
            if (post.isReserved)
              Text(
                ' • ',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            if (post.isReserved)
              Text(
                l10n.reserved,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold
                ),
              ),
          ],
        ),
      ),
    );
  }
}