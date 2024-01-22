import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/home/pages/profile/tabs/review.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileReviewsController {
  void Function()? refresh;
}

class ProfileReviews extends StatefulWidget {
  final bool isMe;
  final ProfileReviewsController? controller;
  final String? UUID;
  final String username;

  const ProfileReviews({Key? key, required this.isMe, this.controller, this.UUID, required this.username}) : super(key: key);

  @override
  State<ProfileReviews> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfileReviews> with AutomaticKeepAliveClientMixin {
  int _offset = 0;
  List<ReviewResponse> _reviews = [];
  bool _hasMore = true;
  int _currentFilter = 0;

  void _getReviews() async {
    String token = (await AccountCache.getToken())!;

    List<ReviewResponse> reviews = [];

    if (widget.isMe) {
      reviews = await Api.v1.accounts.meRoute.reviews.get(token, offset: _offset, type: _currentFilter);
    }

    else if (widget.UUID != null) {
      reviews = await Api.v1.accounts.getUserReviews(token, widget.UUID!, offset: _offset, type: _currentFilter);
    }

    setState(() {
      _reviews.addAll(reviews);
      _hasMore = reviews.length == 10;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.refresh = refresh;
    }

    _getReviews();
  }

  void refresh() {
    setState(() {
      _offset = 0;
      _reviews = [];
      _hasMore = true;
    });
    _getReviews();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2),
      itemCount: _reviews.length + 2,
      itemBuilder: (context, index) {
        AppLocalizations l10n = AppLocalizations.of(context)!;

        if (index == 0) {
          return DropdownButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurfaceVariant
            ),
            style: Theme.of(context).textTheme.labelMedium,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizing.horizontalPadding,
              vertical: Sizing.horizontalPadding / 2
            ),
            isDense: true,
            value: _currentFilter,
            underline: const SizedBox(),
            onChanged: (value) {
              setState(() {
                _currentFilter = value as int;
              });

              refresh();
            },
            items: [
              DropdownMenuItem(
                value: 0,
                child: Text(
                  l10n.all,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text(
                  l10n.asEmployer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(
                  l10n.asEmployee,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          );
        }

        index--;

        if (index == _reviews.length - 1 && _hasMore) {
          _offset += 10;
          _getReviews();
        }

        if (index == _reviews.length) {
          if (!_hasMore) {
            return const SizedBox();
          }

          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CrossPlatformLoader()
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding, vertical: Sizing.horizontalPadding / 2),
          child: Review(
            review: _reviews[index],
            otherUsername: widget.username,
          ),
        );
      },
    );
  }
}