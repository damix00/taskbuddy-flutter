import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileBio extends StatelessWidget {
  final String bio;

  const ProfileBio({Key? key, required this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            Text(
              l10n.biography,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
            Text(
              bio,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )
      )
    );
  }
}