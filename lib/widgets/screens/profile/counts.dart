import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountsList extends StatelessWidget {
  final String followers;
  final String following;
  final String listings;
  final String jobsDone;

  const CountsList(
      {required this.followers,
      required this.following,
      required this.listings,
      required this.jobsDone,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 46,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CountTab(displayCount: followers, displayText: l10n.followers);
          } else if (index == 1) {
            return _CountTab(displayCount: following, displayText: l10n.following);
          } else if (index == 2) {
            return _CountTab(displayCount: listings, displayText: l10n.listings);
          } else {
            return _CountTab(displayCount: jobsDone, displayText: l10n.jobsDone);
          }
        },
        separatorBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 30),
              Container(
                height: 20,
                width: 1,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(50),
              ),
              const SizedBox(width: 30),
            ],
          );
        },
        itemCount: 4,
      ),
    );
  }
}

class _CountTab extends StatelessWidget {
  final String displayCount;
  final String displayText;

  const _CountTab({required this.displayCount, required this.displayText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(displayCount,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onBackground)),
        Text(displayText,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12)),
      ],
    );
  }
}
