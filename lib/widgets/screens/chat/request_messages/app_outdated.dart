import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/request_message_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppOutdated extends StatelessWidget {
  const AppOutdated({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return RequestMessageBase(
      title: l10n.appOutdatedMsg,
      body: l10n.appOutdatedMsgDesc,
    );
  }
}