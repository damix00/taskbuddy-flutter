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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: BlurAppbar.appBar(
          showLeading: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'TaskBuddy',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          )),
      body: Center(
          child: Button(
              child: Text('Log out'),
              onPressed: () {
                AccountCache.setLoggedIn(false);
                Phoenix.rebirth(context);
              })),
    );
  }
}
