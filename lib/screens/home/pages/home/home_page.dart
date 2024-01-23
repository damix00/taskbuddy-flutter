import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/api/responses/sessions/session_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/cache/misc_cache.dart';
import 'package:taskbuddy/screens/home/pages/home/filter_dialog.dart';
import 'package:taskbuddy/screens/home/pages/home/first_time.dart';
import 'package:taskbuddy/state/providers/home_screen.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/posts/post.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class HomePageAppbar extends StatelessWidget {
  const HomePageAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<HomeScreenModel>(
          builder: (context, model, child) {
            return DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              items: [
                DropdownMenuItem(
                  value: SessionType.ALL,
                  child: AppbarTitle(l10n.suggested),
                ),
                DropdownMenuItem(
                  value: SessionType.FOLLOWING,
                  child: AppbarTitle(l10n.imFollowing),
                ),
              ],
              onChanged: (value) {
                model.type = value as int;
              },
              value: model.type,
            );
          }
        ),
        IconButton(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: Theme.of(context).colorScheme.onBackground
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const Dialog(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: FilterDialog()
                  )
                );
              }
            );
          },
        )
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  bool _firstTime = false;
  bool _finished = false;

  int _sessionId = 0;
  List<PostResultsResponse> _posts = [];

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _finished = false;
      _posts.clear();
    });

    String token = (await AccountCache.getToken())!;
    HomeScreenModel model = Provider.of<HomeScreenModel>(context, listen: false);

    // Create a new session
    var data = await Api.v1.sessions.create(
      token,
      lat: LocationState.currentLat,
      lon: LocationState.currentLon,
      type: model.type,
      location: model.postLocationType,
      urgency: model.urgencyType,
      tags: model.filteredTags.map((e) => e.id).toList(),
    );

    if (!data.ok) {
      return;
    }

    _sessionId = data.data!.id;

    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    log("Fetching posts");

    if (_finished) {
      return;
    }

    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }

    String token = (await AccountCache.getToken())!;

    var data = await Api.v1.sessions.getPosts(token, _sessionId);

    setState(() {
      _posts.addAll(data);
      _loading = false;
      _finished = data.isEmpty;
    });
  }

  Future<void> _markFirstTime() async {
    await MiscCache.setFirstTimeScroll(true);
  }

  @override
  void initState() {
    super.initState();

    HomeScreenModel model = Provider.of<HomeScreenModel>(context, listen: false);
    model.addListener(() {
      _init();
    });


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _firstTime = await MiscCache.getFirstTimeScroll();
      
      setState(() {});

      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _posts.length + (_loading ? 1 : 0) + (_firstTime ? 0 : 1) + ((_posts.isEmpty && !_loading && _finished) ? 1 : 0),
      itemBuilder: (context, index) {
        if (!_firstTime && index == 0) {
          return const FirstTime();
        }

        if (!_firstTime) {
          index--;
        }

        if (!_firstTime && index == 1) {
          _markFirstTime();
        }

        if (_loading && index == _posts.length) {
          return const Center(
            child: CrossPlatformLoader(),
          );
        }

        if (index == _posts.length - 1 && !_loading && !_finished) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await _fetchPosts();
          });
        }

        if (_posts.isEmpty && !_loading && _finished) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noPostsFound,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPostsFoundDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return PostLayout(
          post: _posts[index],
        );
      },
    );
  }
}