import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/checkbox.dart';
import 'package:taskbuddy/widgets/input/with_state/location_display.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class EditPostData {
  String title;
  String description;
  LatLng? location;
  String? locationName;
  bool urgent;
  bool reserved;

  EditPostData({
    required this.title,
    required this.description,
    required this.location,
    required this.locationName,
    required this.urgent,
    required this.reserved,
  });
}

class EditPostArguments {
  final PostResultsResponse post;
  final Function(EditPostData)? onEdit;

  EditPostArguments(this.post, this.onEdit);
}

class EditPostScreen extends StatelessWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    var args = ModalRoute.of(context)!.settings.arguments as EditPostArguments;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(
          l10n.editPost
        ),
      ),
      body: _PageContent(
        post: args.post,
        onEdit: args.onEdit,
      ),
      extendBodyBehindAppBar: true,
    );
  }
}

class _PageContent extends StatefulWidget {
  final PostResultsResponse post;
  final Function(EditPostData)? onEdit;

  const _PageContent({Key? key, required this.post, this.onEdit}) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  final _formKey = GlobalKey<FormState>();
  String _updatedTitle = "";
  String _updatedDescription = "";
  LatLng? _updatedLocation;
  String? _updatedLocationName;
  bool _madeChanges = false;
  bool _urgent = false;
  bool _reserved = false;

  @override
  void initState() {
    super.initState();

    _updatedTitle = widget.post.title;
    _updatedDescription = widget.post.description;
    _updatedLocation = widget.post.locationLat == 1000 ? null : LatLng(widget.post.locationLat, widget.post.locationLon);
    _updatedLocationName = widget.post.locationText;
    _urgent = widget.post.isUrgent;
    _reserved = widget.post.isReserved;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
              TextInput(
                label: l10n.title,
                hint: l10n.titlePlaceholder,
                initialValue: widget.post.title,
                maxLength: 100,
                onChanged: (String value) {
                  _updatedTitle = value;

                  if (!_madeChanges) {
                    setState(() {
                      _madeChanges = true;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return l10n.emptyField(l10n.title);
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizing.inputSpacing,),
              TextInput(
                label: l10n.description,
                hint: l10n.descriptionPlaceholder,
                initialValue: widget.post.description,
                maxLines: 3,
                maxLength: 1024,
                onChanged: (String value) {
                  _updatedDescription = value;

                  if (!_madeChanges) {
                    setState(() {
                      _madeChanges = true;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return l10n.emptyField(l10n.description);
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizing.inputSpacing,),
              LocationDisplay(
                location: _updatedLocation?.latitude == 1000 ? null : _updatedLocation,
                locationName: _updatedLocationName,
                onLocationChanged: (LatLng? location, String? name) {
                  setState(() {
                    _updatedLocation = location;
                    _updatedLocationName = name;

                    if (!_madeChanges) {
                      _madeChanges = true;
                    }
                  });
                },
              ),
              const SizedBox(height: Sizing.formSpacing,),
              TBCheckbox(
                value: _urgent,
                onChanged: (bool value) {
                  setState(() {
                    _urgent = value;

                    if (!_madeChanges) {
                      _madeChanges = true;
                    }
                  });
                },
                child: TitleDescSmall(
                  title: l10n.urgent,
                  desc: l10n.urgentDesc,
                )
              ),
              const SizedBox(height: Sizing.inputSpacing,),
              TBCheckbox(
                value: _reserved,
                onChanged: (bool value) {
                  setState(() {
                    _reserved = value;

                    if (!_madeChanges) {
                      _madeChanges = true;
                    }
                  });
                },
                child: TitleDescSmall(
                  title: l10n.reserved,
                  desc: l10n.reservedDesc,
                )
              ),
              const SizedBox(height: Sizing.formSpacing,),
              Button(
                disabled: !_madeChanges,
                child: ButtonText(
                  l10n.edit
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    LoadingOverlay.showLoader(context);

                    String token = (await AccountCache.getToken())!;

                    var res = await Api.v1.posts.updatePost(
                      token,
                      uuid: widget.post.UUID,
                      title: _updatedTitle,
                      description: _updatedDescription,
                      isUrgent: _urgent,
                      isReserved: _reserved,
                      locationLat: _updatedLocation?.latitude,
                      locationLon: _updatedLocation?.longitude,
                      locationName: _updatedLocationName,
                    );

                    LoadingOverlay.hideLoader(context);

                    if (res) {
                      if (widget.onEdit != null) {
                        widget.onEdit!(EditPostData(
                          title: _updatedTitle,
                          description: _updatedDescription,
                          location: _updatedLocation,
                          locationName: _updatedLocationName,
                          urgent: _urgent,
                          reserved: _reserved,
                        ));
                      }

                      Navigator.of(context).pop();

                      SnackbarPresets.show(
                        context,
                        text: l10n.success
                      );
                    } else {
                      SnackbarPresets.error(
                        context,
                        l10n.somethingWentWrong
                      );
                    }
                  }
                }
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding,),
            ],
          ),
        )
      ),
    );
  }
}
