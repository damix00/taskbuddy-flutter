import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _ProfileEditForm extends StatefulWidget {
  final String profilePicture;
  final formKey;

  const _ProfileEditForm({required this.profilePicture, required this.formKey, Key? key}) : super(key: key);

  @override
  __ProfileEditFormState createState() => __ProfileEditFormState();
}

class __ProfileEditFormState extends State<_ProfileEditForm> {
  bool _showChild = true;
  XFile? _image;

  void _onSelected(XFile? file) async {
    setState(() {
      _image = file;
      _showChild = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Form(
        key: widget.formKey, 
        child: Column(
          children: [
            const SizedBox(height: Sizing.horizontalPadding,),
            ProfilePictureInput(
              onSelected: _onSelected,
              image: _image,
              child: (_showChild && widget.profilePicture.isNotEmpty)
                ? ProfilePictureDisplay(size: 60, iconSize: 32, profilePicture: widget.profilePicture)
                : null,
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            Row(
              children: [
                Flexible(
                  child: TextInput(
                    label: l10n.firstName,
                    hint: "John",
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: Sizing.inputSpacing,),
                Flexible(
                  child: TextInput(
                    label: l10n.lastName,
                    hint: "Doe",
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ]
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            TextInput(
              label: l10n.username,
              hint: "@johndoe",
              textInputAction: TextInputAction.next,
              tooltipText: l10n.usernameTooltip
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            TextInput(
              label: l10n.biography,
              optional: true,
              hint: 'g'
            ),
          ]
        )
      ),
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
            Consumer<AuthModel>(
              builder: (context, value, child) {
                return _ProfileEditForm(formKey: _formKey, profilePicture: value.profilePicture,);
              }
            ),
          ],
        ),
      )
    );
  }
}
