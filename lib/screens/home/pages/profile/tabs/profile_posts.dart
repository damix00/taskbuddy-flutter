import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/post_card/post_card.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class ProfilePostsController {
  void Function()? refresh;
}

class ProfilePosts extends StatefulWidget {
  final bool isMe;
  final String? UUID;
  final ProfilePostsController? controller;

  const ProfilePosts({Key? key, required this.isMe, this.controller, this.UUID}) : super(key: key);

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> with AutomaticKeepAliveClientMixin {
  int _offset = 0;
  List<PostResponse> _posts = [];
  bool _hasMore = true;

  void _getPosts() async {
    String token = (await AccountCache.getToken())!;

    List<PostResponse> posts = [];

    if (widget.isMe) {
      posts = await Api.v1.accounts.meRoute.posts.get(token, offset: _offset);
    }

    setState(() {
      _posts.addAll(posts);
      _hasMore = posts.length == 10;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.refresh = refresh;
    }

    _getPosts();
  }

  void refresh() {
    setState(() {
      _offset = 0;
      _posts = [];
      _hasMore = true;
    });
    _getPosts();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      itemCount: _posts.length + 1,
      itemBuilder: (context, index) {
        if (index == _posts.length - 1 && _hasMore) {
          _offset += 10;
          _getPosts();
        }

        if (index == _posts.length) {
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

        return Touchable(
          onTap: () {
            Navigator.of(context).pushNamed('/post', arguments: PostScreenArguments(post: PostResultsResponse.fromPostResponse(_posts[index])));
          },
          child: PostCard(post: PostResultsResponse.fromPostResponse(_posts[index])),
        );
      },
    );
  }
}