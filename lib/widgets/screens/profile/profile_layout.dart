import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taskbuddy/widgets/screens/profile/bio.dart';
import 'package:taskbuddy/widgets/screens/profile/counts.dart';
import 'package:taskbuddy/widgets/screens/profile/ratings.dart';
import 'package:taskbuddy/widgets/ui/default_profile_picture.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

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
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Appbar padding
          SizedBox(
              height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
          // Content padding
          const SizedBox(
            height: 32,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(156),
            child: SizedBox(
              height: 156,
              width: 156,
              child: CachedNetworkImage(
                  imageUrl: profilePicture,
                  errorWidget: (context, url, error) =>
                      const DefaultProfilePicture(size: 156)),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(fullName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground)),
            ],
          ),
          const SizedBox(height: 16),
          CountsList(
              followers: followers,
              following: following,
              listings: listings,
              jobsDone: jobsDone),
          bio != '' ? ProfileBio(bio: bio) : Container(),
          const SizedBox(height: 16),
          ProfileRatings(employerRating: employerRating, employerCancelRate: employerCancelRate, employeeRating: employeeRating, employeeCancelRate: employeeCancelRate),
          const SizedBox(height: 16,),
          Column(
            children: actions,
          ),
          const SizedBox(height: 16,),
          Container(
            width: double.infinity,
            height: 1,
            color: Theme.of(context).colorScheme.surfaceVariant,
          )
        ],
      ),
    );
  }
}
