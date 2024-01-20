import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';

class Review extends StatelessWidget {
  final ReviewResponse review;

  const Review({ Key? key, required this.review }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: ProfilePictureDisplay(
            size: 56,
            iconSize: 22,
            profilePicture: review.user.profile.profilePicture
          ),
        ),
      ],
    );
  }
}