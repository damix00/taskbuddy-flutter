import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/profile/profile_layout.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/not_found.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final String? UUID;
  final String? username;
  final PublicAccountResponse? account;

  const ProfileScreen({Key? key, this.UUID, this.username, this.account}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  bool _notFound = false;
  PublicAccountResponse? _account;
  bool _isMe = false;

  void _loadAccount() async {
    if (widget.account != null) return;

    setState(() {
      _loading = true;
    });

    if (widget.UUID != null) {
      String token = (await AccountCache.getToken())!;

      var account = await Api.v1.accounts.fetchAccount(token, widget.UUID!);

      if (!account.ok) {
        setState(() {
          _notFound = true;
          _loading = false;
        });

        return;
      } else {
        setState(() {
          _account = account.data;
          _loading = false;
          _notFound = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.UUID == null && widget.account == null) {
      throw Exception('UUID and account cannot both be null');
    }

    if (widget.account != null) {
      _loading = false;
      _account = widget.account;
    }

    var auth = Provider.of<AuthModel>(context, listen: false);
    _isMe = auth.UUID == widget.UUID;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    if (widget.UUID == null && widget.account == null) {
      throw Exception('UUID and account cannot both be null');
    }

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle("@${_account?.username ?? widget.username ?? l10n.username}"),
      ),
      body: _loading
        ? const Center(
            child: CrossPlatformLoader()
          )
        : _notFound
          ? const NotFound()
          : _ProfileScreenContent(account: _account!, isMe: _isMe,),
    );
  }
}

class _ProfileScreenContent extends StatefulWidget {
  final PublicAccountResponse account;
  final bool isMe;

  const _ProfileScreenContent({Key? key, required this.account, required this.isMe}) : super(key: key);

  @override
  State<_ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<_ProfileScreenContent> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ProfileLayout(
      profilePicture: widget.account.profile.profilePicture,
      fullName: "${widget.account.firstName} ${widget.account.lastName}",
      followers: Utils.formatNumber(widget.account.profile.followers),
      following: Utils.formatNumber(widget.account.profile.following),
      listings: Utils.formatNumber(widget.account.profile.posts),
      jobsDone: Utils.formatNumber(widget.account.profile.completedEmployee + widget.account.profile.completedEmployer),
      bio: widget.account.profile.bio,
      employerRating: widget.account.profile.posts > 0 ? widget.account.profile.ratingEmployer / widget.account.profile.posts : 0,
      employerCancelRate: widget.account.profile.cancelledEmployer > 0 && widget.account.profile.completedEmployer == 0 
        ? 100
        : widget.account.profile.cancelledEmployer > 0 && widget.account.profile.completedEmployer > 0
          ? (widget.account.profile.cancelledEmployer / widget.account.profile.completedEmployer) * 100
          : 0,
      employeeRating: widget.account.profile.posts > 0 ? widget.account.profile.ratingEmployee / widget.account.profile.posts : 0,
      employeeCancelRate: widget.account.profile.cancelledEmployee > 0 && widget.account.profile.completedEmployee == 0 
        ? 100
        : widget.account.profile.cancelledEmployee > 0 && widget.account.profile.completedEmployee > 0
          ? (widget.account.profile.cancelledEmployee / widget.account.profile.completedEmployee) * 100
          : 0,
      locationText: widget.account.profile.locationText,
      isMe: widget.isMe,
      UUID: widget.account.UUID,
      username: widget.account.username,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: SlimButton(
            type: ButtonType.outlined,
            child: Text(
              widget.isMe ? l10n.editProfile : (widget.account.isFollowing ? AppLocalizations.of(context)!.unfollow : AppLocalizations.of(context)!.follow),
            ),
            onPressed: () async {
              if (widget.isMe) {
                Navigator.of(context).pushNamed('/profile/edit');
                return;
              }

              String token = (await AccountCache.getToken())!;

              bool res = false;

              if (widget.account.isFollowing) {
                res = await Api.v1.accounts.unfollow(token, widget.account.UUID);
              } else {
                res = await Api.v1.accounts.follow(token, widget.account.UUID);
              }

              if (!res) {
                SnackbarPresets.error(
                  context,
                  l10n.somethingWentWrong,
                );

                return;
              }

              SnackbarPresets.show(
                context,
                text: widget.account.isFollowing ? l10n.successfullyUnfollowed : l10n.successfullyFollowed
              );

              setState(() {
                widget.account.isFollowing = !widget.account.isFollowing;
              });
            },
          ),
        )
      ]
    );
  }
}
