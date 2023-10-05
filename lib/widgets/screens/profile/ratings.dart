import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileRatings extends StatelessWidget {
  final num employerRating;
  final num employerCancelRate;
  final num employeeRating;
  final num employeeCancelRate;

  const ProfileRatings({
    Key? key,
    required this.employerRating,
    required this.employerCancelRate,
    required this.employeeRating,
    required this.employeeCancelRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            _Rating(
              title: AppLocalizations.of(context)!.employerRating,
              rating: employerRating,
              cancelRate: employerCancelRate,
            ),
            _Rating(
              title: AppLocalizations.of(context)!.employeeRating,
              rating: employeeRating,
              cancelRate: employeeCancelRate,
            ),
          ],
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final String title;
  final num rating;
  final num cancelRate;

  const _Rating({
    Key? key,
    required this.title,
    required this.rating,
    required this.cancelRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700
            )
          ),
          const SizedBox(height: 4,),
          RatingBarIndicator(
            rating: rating.toDouble(),
            itemBuilder: (context, index) => Icon(
              Icons.star_rate,
              color: Theme.of(context).colorScheme.primary,
            ),
            unratedColor: Theme.of(context).colorScheme.onSurfaceVariant,
            itemCount: 5,
            itemSize: 24,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 4,),
          Text('$rating/5', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 2,),
          Text(
            AppLocalizations.of(context)!.cancellationRate(cancelRate),
            style: const TextStyle(
              fontSize: 12,
            )
          ),
        ],
      ),
    );
  }
}
