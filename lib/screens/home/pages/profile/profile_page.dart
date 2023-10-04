import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/navigation/homescreen_appbar.dart';
import 'package:taskbuddy/widgets/screens/profile_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _fullName = '';
  String _profilePicture = '';
  String _followers = '';
  String _following = '';
  String _listings = '';
  String _jobsDone = '';
  String _bio = '';
  double _employerRating = 0;
  double _employeeRating = 0;
  String _employerCancelRate = '';
  String _employeeCancelRate = '';

  @override
  void initState() {
    super.initState();

    AuthModel auth = Provider.of<AuthModel>(context, listen: false);

    _username = auth.username;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          HomescreenAppbar(
            children: [
              Text(
                '@$_username',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Touchable(
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              )
            ],
          ),
          ProfileLayout(
            profilePicture: _profilePicture,
            actions: [
              Button(
                child: Text('Edit profile'),
                onPressed: () {},
              )
            ]
          )
        ],
      ),
    );
  }
}
