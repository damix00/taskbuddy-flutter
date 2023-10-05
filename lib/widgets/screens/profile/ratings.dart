import 'package:flutter/material.dart';

class ProfileRatings extends StatelessWidget {
  final num employerRating;
  final String employerCancelRate;
  final num employeeRating;
  final String employeeCancelRate;

  const ProfileRatings({
    Key? key,
    required this.employerRating,
    required this.employerCancelRate,
    required this.employeeRating,
    required this.employeeCancelRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Ratings'),
      ),
    );
  }
}
