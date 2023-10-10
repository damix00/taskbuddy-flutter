import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/screens/profile/header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileLayout extends StatelessWidget {
  final String profilePicture;
  final List<Widget> actions;
  final String fullName;
  final String followers;
  final String following;
  final String listings;
  final String jobsDone;
  final String bio;
  final num employerRating;
  final num employerCancelRate;
  final num employeeRating;
  final num employeeCancelRate;
  final String? locationText;
  final bool isMe;

  const ProfileLayout(
      {required this.profilePicture,
      required this.actions,
      required this.fullName,
      required this.followers,
      required this.following,
      required this.listings,
      required this.jobsDone,
      required this.bio,
      required this.employerRating,
      required this.employerCancelRate,
      required this.employeeRating,
      required this.employeeCancelRate,
      this.isMe = false,
      this.locationText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        body: Column(
          children: [
            TabBar(
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.listings,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.reviews,
                  ),
                ],
              ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    children: Colors.primaries.map((color) {
                      return Container(color: color, height: 150.0);
                    }).toList(),
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: Colors.primaries.map((color) {
                      return Container(color: color, height: 150.0);
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                ProfileHeader(
                  profilePicture: profilePicture,
                  actions: actions,
                  fullName: fullName,
                  followers: followers,
                  following: following,
                  listings: listings,
                  jobsDone: jobsDone,
                  employeeCancelRate: employeeCancelRate,
                  employeeRating: employeeRating,
                  employerCancelRate: employerCancelRate,
                  employerRating: employerRating,
                  bio: bio.trim(),
                  locationText: locationText,
                  isMe: isMe,
                ),
              ]),
            )
          ];
        },
      ),
    );
  }
}
