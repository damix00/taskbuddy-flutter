import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/home/pages/home_page.dart';
import 'package:taskbuddy/screens/home/pages/messages_page.dart';
import 'package:taskbuddy/screens/home/pages/profile/profile_page.dart';
import 'package:taskbuddy/screens/home/pages/search_page.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/navigation/bottom_navbar.dart';
import 'package:taskbuddy/widgets/navigation/homescreen_appbar.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void init() async {
    String? token = await AccountCache.getToken();

    if (token == null) {
      // If the token is null, then the user is not logged in so restart the app
      Phoenix.rebirth(context);
    }

    ApiResponse<AccountResponse?> me = await Api.v1.accounts.me(token!);

    if (me.status == 401) {
      // If the status code is 401, then the token is invalid so restart the app

      // Remove the token from the cache
      AccountCache.setLoggedIn(false);

      Phoenix.rebirth(context);
    } else if (me.ok) {
      // If the response is OK, then the user is logged in
      AccountCache.saveAccountResponse(me.data!);
      if (me.data!.profile != null) {
        AccountCache.saveProfile(me.data!.profile!);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the state
    init();
  }

  var pages = [
    const HomePage(),
    const SearchPage(),
    Container(),
    const MessagesPage(),
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
          BottomNavbarItem(
              icon: Icons.search_outlined, activeIcon: Icons.search),
          BottomNavbarItem(
              child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Icon(Icons.add,
                color: Theme.of(context).colorScheme.onPrimary),
          )),
          BottomNavbarItem(icon: Icons.chat_outlined, activeIcon: Icons.chat),
          BottomNavbarItem(
              icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: _currentIndex,
        onSelected: (index) {
          setState(() {
            if (index == 2) {
              // If the index is 2, then the user tapped the middle button (add)
              // So we don't want to change the current index
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
        Text('Home'),
        Container(),
        Container(),
        Container(),
        ProfileAppbar(),
      ][widget.currentIndex],
    );
  }
}
