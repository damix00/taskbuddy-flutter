import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/navigation/bottom_navbar.dart';

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
      Phoenix.rebirth(context);
    } else if (me.ok) {
      // If the response is OK, then the user is logged in
      AccountCache.saveAccountResponse(me.data!);
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the state
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CustomBottomNavbar(
        items: [
          BottomNavbarItem(icon: Icons.home_outlined, activeIcon: Icons.home),
          BottomNavbarItem(icon: Icons.search_outlined, activeIcon: Icons.search),
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
            } else {
              _currentIndex = index;
            }
          });
        },
      ),
      appBar: BlurAppbar.appBar(
        showLeading: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'TaskBuddy',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        )
      ),
      body: Center(
        child: Button(
          child: Text('Log out'),
          onPressed: () {
            AccountCache.setLoggedIn(false);
            Phoenix.rebirth(context);
          }
        )
      ),
    );
  }
}
