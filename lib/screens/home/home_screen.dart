import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_tags_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/api/socket/socket.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/home/pages/home_page.dart';
import 'package:taskbuddy/screens/home/pages/chats/chats_page.dart';
import 'package:taskbuddy/screens/home/pages/profile/profile_page.dart';
import 'package:taskbuddy/screens/home/pages/search_page.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/navigation/bottom_navbar.dart';
import 'package:taskbuddy/widgets/navigation/homescreen_appbar.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/required_actions_overlay.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _setActions = false;
  bool _authFetched = false;
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _called = false;

  void updateRequiredActions(AccountResponseRequiredActions? requiredActions) {
    if (_setActions) {
      // If the actions are already set, then don't set them again
      return;
    }
    
    if (requiredActions != null && (requiredActions.verifyEmail || requiredActions.verifyPhoneNumber)) {
      // If the user has required actions, then show the overlay
      _setActions = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add a post frame callback to make sure that the overlay is shown after the build method is called
        // Otherwise, the overlay will not be shown
        showOverlay((context, progress) => const RequiredActionsOverlay(), duration: Duration.zero);
      });
    }
  }

  Future<bool> _fetchMe(String token) async {
    ApiResponse<AccountResponse?> me = await Api.v1.accounts.me(token);

    if (me.status == 401) {
      // If the status code is 401, then the token is invalid so restart the app

      // Remove the token from the cache
      AccountCache.setLoggedIn(false);

      Utils.restartLoggedOut(context);

      return true;
    }

    if (me.data == null) {
      log('Auth response is null');

      return false;
    }

    _authFetched = true;

    if (me.ok) {
      // If the response is OK, then the user is logged in
      AccountCache.saveAccountResponse(me.data!);
      if (me.data!.profile != null) {
        AccountCache.saveProfile(me.data!.profile!);
      }

      AccountCache.setRequiredActions(me.data!.requiredActions);

      Provider.of<AuthModel>(context, listen: false).setAccountResponse(me.data!);
 
      // Show a popup if the user has required actions
      updateRequiredActions(me.data!.requiredActions);
    }

    return true;
  }

  Future<bool> _fetchTags() async {
    ApiResponse<PostTagsResponse?> tags = await Api.v1.posts.tags();

    if (tags.data == null || !tags.ok) {
      log('Tags response is null');

      return false;
    }

    if (tags.ok) {
      // If the response is OK, then save the tags
      Provider.of<TagModel>(context, listen: false).saveResponse(tags.data!);
    }

    return true;
  }

  Future<bool> _fetchData(String token) async {
    if (!(await _fetchMe(token))) {
      log('Failed to fetch auth data');
      return false;
    }

    if (!(await _fetchTags())) {
      log('Failed to fetch tags data');
      return false;
    }

    var messages = Provider.of<MessagesModel>(context, listen: false);
    await messages.fetchMessages();

    return true;
  }

  void _handleConnected() async {
    if (_authFetched) {
      // If the auth has already been fetched, then don't fetch it again
      return;
    }

    if (await _fetchData((await AccountCache.getToken())!)) {
      log('Successfully fetched data, cancelling interval');
      _subscription?.cancel();
    }
    else {
      // If the auth has not been fetched, then fetch it again
      log('Failed to fetch data, trying again in 10 seconds');
      _setInterval();
    }
  }

  void _setInterval() {
    // Set an interval to fetch the data every 5 seconds
    Future.delayed(const Duration(seconds: 10), () async {
      String token = (await AccountCache.getToken())!;
      var connectivityResult = await (Connectivity().checkConnectivity());

      log('Attempting to fetch...');

      // if user is offline, or there is a server error, then set the interval again
      if (!(await _fetchData(token)) || connectivityResult == ConnectivityResult.none) {
        _setInterval();
      }
      else {
        log('Successfully fetched data, cancelling interval');
        _subscription?.cancel();
      }
    });
  }

  void _askPermissions() async {
    var hasPermission = await Geolocator.checkPermission();
    AppLocalizations l10n = AppLocalizations.of(context)!;

    if (hasPermission == LocationPermission.denied || hasPermission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text(l10n.locationPermissionTitle, style: Theme.of(ctx).textTheme.titleSmall),
          content: Text(l10n.locationPermissionDesc, style: Theme.of(ctx).textTheme.bodyMedium),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(ctx).pop()
            ),
            TextButton(
              child: Text(l10n.continueText),
              onPressed: () async {
                await Geolocator.requestPermission();

                Navigator.of(ctx).pop();
              },
            ),
          ],
        )
      );
    }

  }

  void _init() async {
    String? token = await AccountCache.getToken();

    // Connect to the socket
    SocketClient.connect();

    _askPermissions();

    LocationState.setInterval();

    var connectivityResult = await (Connectivity().checkConnectivity());

    _subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (!_called) return; // Don't handle the first event
      _called = true;
      if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
        _handleConnected();
      }
    });

    if (token == null) {
      // If the token is null, then the user is not logged in so restart the app
      Utils.restartLoggedOut(context);
    }

    if (connectivityResult == ConnectivityResult.none) {
      SnackbarPresets.error(context, AppLocalizations.of(context)!.offlineWarning);
      _setInterval(); // Set the interval to fetch the data every 5 seconds
      return;
    }

    AccountResponseRequiredActions? requiredActions = await AccountCache.getRequiredActions();
    
    // Get the required actions from the cache and show a popup accordingly
    updateRequiredActions(requiredActions);

    if (!(await _fetchData(token!))) {
      log('Setting interval because failed to fetch data');
      _setInterval(); // Set the interval to fetch the data every 5 seconds
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the state
    _init();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  var pages = [
    const HomePage(),
    const SearchPage(),
    Container(),
    const ChatsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    Utils.overrideColors(); // Override the status bar color

    return Scaffold(
      extendBodyBehindAppBar: 4 != _currentIndex,
      extendBody: true,
      bottomNavigationBar: CustomBottomNavbar(
        items: [
          BottomNavbarItem(icon: Icons.home_outlined, activeIcon: Icons.home),
          BottomNavbarItem(icon: Icons.search, activeIcon: Icons.search_outlined),
          BottomNavbarItem(
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
            )
          ),
          BottomNavbarItem(icon: Icons.chat_outlined, activeIcon: Icons.chat),
          BottomNavbarItem(icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: _currentIndex,
        onSelected: (index) {
          setState(() {
            if (index == 2) {
              // If the index is 2, then the user tapped the middle button (add)
              // So we don't want to change the current index
              // Instead, we want to open the create post page
              Navigator.of(context).pushNamed('/create-post');
            } else {
              _currentIndex = index;
            }
          });
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top + Sizing.appbarHeight),
        child: _HomeAppbarHandler(currentIndex: _currentIndex,)
      ),
      // IndexedStack is used to keep the state of the pages
      // So that when the user switches between pages, the state is not lost
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
    );
  }
}

class _HomeAppbarHandler extends StatefulWidget {
  final int currentIndex;

  const _HomeAppbarHandler({required this.currentIndex, Key? key}) : super(key: key);

  @override
  State<_HomeAppbarHandler> createState() => _HomeAppbarHandlerState();
}

class _HomeAppbarHandlerState extends State<_HomeAppbarHandler> {
  @override
  Widget build(BuildContext context) {
    return HomescreenAppbar(
      forceDisableBlur: 4 == widget.currentIndex,
      child: [
        const HomePageAppbar(),
        const SearchAppbar(),
        Container(),
        const ChatsAppbar(),
        const ProfileAppbar(),
      ][widget.currentIndex],
    );
  }
}