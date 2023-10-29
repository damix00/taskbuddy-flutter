import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyPhoneFirstPage extends StatefulWidget {
  final VoidCallback onContinue;

  const VerifyPhoneFirstPage({Key? key, required this.onContinue})
      : super(key: key);

  @override
  State<VerifyPhoneFirstPage> createState() => _VerifyPhoneFirstPageState();
}

class _VerifyPhoneFirstPageState extends State<VerifyPhoneFirstPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.verifyPhoneNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(l10n.verifyPhoneNumberDesc,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Button(
            loading: _loading,
            onPressed: () async {
              setState(() {
                _loading = true;
              });

              await Api.v1.accounts.verification.phone.send((await AccountCache.getToken())!);

              setState(() {
                _loading = false;
              });

              widget.onContinue();
            },
            child: Text(
              l10n.continueText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
