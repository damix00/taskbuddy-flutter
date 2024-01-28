import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/screens/profile/profile_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class PostSearch extends StatefulWidget {
  final String query;

  const PostSearch({Key? key, required this.query}) : super(key: key);

  @override
  State<PostSearch> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> with AutomaticKeepAliveClientMixin {
  List<PostResultsResponse> _results = [];
  int _offset = 0;
  bool _hasMore = true;
  bool _loading = true;

  Future<void> _search() async {
    String token = (await AccountCache.getToken())!;

    var response = await Api.v1.posts.searchPosts(token, widget.query, _offset);

    if (!response.ok) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _results.addAll(response.data!);

    if (response.data!.length < 10) {
      _hasMore = false;
    }

    _offset += 10;

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _search();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: Sizing.horizontalPadding),
        ),
        if (_loading)
          const SliverToBoxAdapter(
            child: CrossPlatformLoader(),
          )
        
        else if (_results.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(l10n.noResults),
              ),
            ),
          )
        
        else
          SliverList.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              if (index == _results.length - 1 && _hasMore) {
                _search();
              }

              return Column(
                children: [
                  _PostDisplay(post: _results[index]),

                  if (index != _results.length - 1)
                    const CustomDivider(padding: Sizing.horizontalPadding),
                ],
              );
            },
          ),

        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding,))
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _PostDisplay extends StatefulWidget {
  final PostResultsResponse post;

  const _PostDisplay({Key? key, required this.post}) : super(key: key);

  @override
  State<_PostDisplay> createState() => _PostDisplayState();
}

class _PostDisplayState extends State<_PostDisplay> {
  void _openProfile() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          UUID: widget.post.user.UUID,
          username: widget.post.user.username,
        )
      )
    );
  }

  void _openPost() {
    Navigator.of(context).pushNamed("/post", arguments: PostScreenArguments(post: widget.post));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Touchable(
                onTap: _openProfile,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: ProfilePictureDisplay(
                    size: 36,
                    iconSize: 20,
                    profilePicture: widget.post.user.profilePicture
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Touchable(
                  onTap: _openProfile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.post.user.firstName} ${widget.post.user.lastName}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                      Text(
                        "@${widget.post.user.username}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall
                      ),
                    ],
                  ),
                )
              ),
              const SizedBox(width: 12),
              FeedSlimButton(
                child: Text(
                  widget.post.user.isFollowing ? l10n.unfollow : l10n.follow,
                ),
                onPressed: () async {
                  String token = (await AccountCache.getToken())!;
          
                  if (widget.post.user.isFollowing) {
                    await Api.v1.accounts.unfollow(token, widget.post.user.UUID);
                  } else {
                    await Api.v1.accounts.follow(token, widget.post.user.UUID);
                  }
          
                  widget.post.user.isFollowing = !widget.post.user.isFollowing;
          
                  setState(() {});
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          Touchable(
            onTap: _openPost,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.post.description,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12), 
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.media[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
