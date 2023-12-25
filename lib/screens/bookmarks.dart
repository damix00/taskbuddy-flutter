import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/feedback/custom_refresh.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/post_card/post_card.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.saved),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _ScreenContent(),
    );
  }
}

class _ScreenContent extends StatefulWidget {
  const _ScreenContent({Key? key}) : super(key: key);

  @override
  State<_ScreenContent> createState() => _ScreenContentState();
}

class _ScreenContentState extends State<_ScreenContent> {
  List<PostResultsResponse> _posts = [];
  bool _loading = true;
  bool _hasMore = true;
  int _offset = 0;

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
    });

    String token = (await AccountCache.getToken())!;

    List<PostResultsResponse> posts = await Api.v1.accounts.meRoute.posts.getBookmarks(token, offset: _offset);

    setState(() {
      _posts.addAll(posts);
      _loading = false;
      _offset += posts.length;
      _hasMore = posts.length == 10;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    EdgeInsets p = MediaQuery.of(context).padding;

    return CustomRefresh(
      paddingTop: p.top,
      onRefresh: () async {
        setState(() {
          _offset = 0;
          _posts = [];
          _hasMore = true;
        });
        _loadPosts();
      },
      child: ListView.builder(
        itemCount: _posts.length + 1,
        padding: EdgeInsets.only(bottom: p.bottom + Sizing.horizontalPadding),
        itemBuilder: (context, index) {
          if (index == _posts.length - 1 && _hasMore) {
            _loadPosts();
          }
    
          if (index == _posts.length) {
            if (!_loading) return Container();
    
            return const Padding(
              padding: EdgeInsets.only(top: Sizing.horizontalPadding),
              child: CrossPlatformLoader()
            );
          }
    
          return Touchable(
            onTap: () {
              Navigator.of(context).pushNamed('/post', arguments: PostScreenArguments(post: _posts[index]));
            },
            child: PostCard(
              post: _posts[index],
            ),
          );
        },
      ),
    );
  }
}
