import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/screens/search/search_screen.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/search_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/feedback/custom_refresh.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/post_card/post_card.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class SearchAppbar extends StatelessWidget {
  const SearchAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppbarTitle(l10n.search)
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _loading = true;
  bool _error = false;
  bool _isLocationEnabled = false;

  List<PostResultsResponse> _posts = [];

  Future<void> _load() async {
    await LocationState.updateLocation();

    bool canGetLocation = await Utils.canGetLocation();

    if (canGetLocation) {
      setState(() {
        _isLocationEnabled = true;
      });
    }
    
    else {
      setState(() {
        _loading = false;
        _error = false;
        _isLocationEnabled = false;
      });

      return;
    }

    String token = (await AccountCache.getToken())!;

    var data = await Api.v1.posts.getNearbyPosts(token, LocationState.currentLat, LocationState.currentLon, 0);

    if (!data.ok) {
      setState(() {
        _loading = false;
        _error = true;
      });
      return;
    }

    setState(() {
      _loading = false;
      _error = false;
      _posts = data.data!;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CustomRefresh(
      paddingTop: MediaQuery.of(context).padding.top,
      onRefresh: () async {
        await _load();
      },
      notificationPredicate: (notification) {
        // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
        return notification.depth == 2 || notification.depth == 0;
      },
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: Sizing.horizontalPadding,)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
              child: Hero(
                tag: 'search',
                child: Material(
                  child: SearchInput(
                    hintText: l10n.search,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabled: false,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen()
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: CustomDivider(padding: Sizing.horizontalPadding,)),
          if (_loading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CrossPlatformLoader(),
              ),
            ),
          if (_error && !_loading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(l10n.somethingWentWrong),
                ),
              ),
            ),
          if (!_loading && !_isLocationEnabled)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(l10n.locationOff),
                ),
              ),
            ),
          
          if (!_loading && !_error && _isLocationEnabled)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding).copyWith(bottom: Sizing.horizontalPadding / 2),
                child: Text(
                  l10n.nearbyPosts,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w900
                  ),
                ),
              )
            ),

          if (!_loading && !_error && _isLocationEnabled)
            _NearbyPosts(posts: _posts)
        ],
      ),
    );
  }
}

class _NearbyPosts extends StatelessWidget {
  final List<PostResultsResponse> posts;

  const _NearbyPosts({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SliverList.builder(
      itemCount: posts.length == 0 ? 1 : posts.length,
      itemBuilder: (context, index) {
        if (posts.length == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2),
            child: Center(
              child: Text(l10n.noPostsFound),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2, horizontal: Sizing.horizontalPadding),
          child: Touchable(
            onTap: () {
              Navigator.of(context).pushNamed('/post', arguments: PostScreenArguments(post: posts[index]));
            },
            child: PostCard(post: posts[index], padding: false,)
          ),
        );
      },
    );
  }
}
