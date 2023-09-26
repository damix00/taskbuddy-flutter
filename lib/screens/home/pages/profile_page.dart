import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Button(
        child: Text('Log out'),
        onPressed: () {
          AccountCache.setLoggedIn(false);
          Phoenix.rebirth(context);
        }
      )
    );
  }
}
