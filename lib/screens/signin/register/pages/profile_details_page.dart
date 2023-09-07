import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
          child: Text(
        'Profile Details',
        style: Theme.of(context).textTheme.titleSmall,
      )),
    );
  }
}
