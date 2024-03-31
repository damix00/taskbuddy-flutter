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
import 'package:taskbuddy/state/providers/location.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/posts/post.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class HomePageController {
  void Function()? onHomeIconTap;
}

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
            HomeScreenModel model = Provider.of<HomeScreenModel>(context, listen: false);
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: FilterDialog(
                      filteredTags: model.filteredTags,
                      postLocationType: model.postLocationType,
                      urgencyType: model.urgencyType,
                      minPrice: model.minPrice,
                      maxPrice: model.maxPrice,
                      onFilter: (data) {
                        model.setData(
                          model.type,
                          data.postLocationType,
                          data.urgencyType,
                          data.filteredTags,
                          minPrice: data.minPrice,
                          maxPrice: data.maxPrice
                        );
                      },
                    )
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
  final HomePageController? controller;

  const HomePage({Key? key, this.controller}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  bool _firstTime = false;
  bool _finished = false;

  bool _initiated = false;
  final _pageController = PageController();

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
      minPrice: model.minPrice,
      maxPrice: model.maxPrice
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

  void _onHomeIconTap() {
    if (_loading) {
      return;
    }

    if (_pageController.page == 0) {
      HomeScreenModel model = Provider.of<HomeScreenModel>(context, listen: false);
      
      model.refresh();
    }

    else if (_pageController.page != null) {
      _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _startLoad() {
    LocationModel locationModel = Provider.of<LocationModel>(context, listen: false);

    if (locationModel.loaded && !_initiated) {
      _initiated = true;

      // Listen for changes in filters
      HomeScreenModel model = Provider.of<HomeScreenModel>(context, listen: false);
      model.addListener(() {
        _init();
      });

      _init();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.onHomeIconTap = _onHomeIconTap;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _firstTime = await MiscCache.getFirstTimeScroll();
      
      setState(() {});

      LocationModel locationModel = Provider.of<LocationModel>(context, listen: false);
      locationModel.addListener(() {
        _startLoad();
      });

      _startLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
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