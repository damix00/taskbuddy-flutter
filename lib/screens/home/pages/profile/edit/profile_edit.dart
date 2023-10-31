import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/dialog/dialog.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class _ProfileEditForm extends StatefulWidget {
  final formKey;

  const _ProfileEditForm({required this.formKey, Key? key}) : super(key: key);

  @override
  __ProfileEditFormState createState() => __ProfileEditFormState();
}

class __ProfileEditFormState extends State<_ProfileEditForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey, 
      child: Column(
        children: [
        ]
      )
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _madeChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 24),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (ctx) => WillPopScope(onWillPop: () async => false, child: const CustomDialog()),
                  barrierDismissible: false,
                  barrierColor: Colors.black,
                );

                await Future.delayed(Duration(seconds: 3));

                Navigator.of(context).pop();
              }
            ),
            Text(
              AppLocalizations.of(context)!.editProfile,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.check, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        showLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
            _ProfileEditForm(formKey: _formKey,),
          ],
        ),
      )
    );
  }
}
