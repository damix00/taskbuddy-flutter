import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/navigation/homescreen_appbar.dart';
import 'package:taskbuddy/widgets/screens/profile/profile_layout.dart';

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
  num _employerRating = 0;
  num _employeeRating = 0;
  num _employerCancelRate = 0;
  num _employeeCancelRate = 0;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();

    AuthModel auth = Provider.of<AuthModel>(context, listen: false);

    _username = auth.username;
    _fullName = auth.fullName;
    _profilePicture = auth.profilePicture;
    _followers = Utils.formatNumber(auth.followers);
    _following = Utils.formatNumber(auth.following);
    _listings = Utils.formatNumber(auth.listings);
    _jobsDone = Utils.formatNumber(auth.jobsDone);
    _bio = auth.bio;
    _employerRating = auth.employerRating;
    _employeeRating = auth.employeeRating;
    _employerCancelRate = (auth.employerCancelled / auth.listings) * 100;
    _employeeCancelRate = (auth.employeeCancelled / auth.jobsDone) * 100;
    _isPrivate = auth.isPrivate;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfileLayout(
          fullName: _fullName,
          profilePicture: _profilePicture,
          followers: _followers,
          following: _following,
          listings: _listings,
          jobsDone: _jobsDone,
          actions: [
            Button(
              child: Text('Edit profile'),
              onPressed: () {},
            )
          ]
        ),
        HomescreenAppbar(
          children: [
            Row(
              children: [
                Text(
                  '@$_username',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                _isPrivate ? const _PrivateProfileIcon() : Container()
              ],
            ),
            Touchable(
              child: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _PrivateProfileIcon extends StatelessWidget {
  const _PrivateProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4,),
        Icon(
          Icons.lock_outline,
          size: 16,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }
}
