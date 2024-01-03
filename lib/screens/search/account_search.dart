import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/profile_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class SearchResultsAccounts extends StatefulWidget {
  final String query;

  const SearchResultsAccounts({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultsAccounts> createState() => _SearchResultsAccountsState();
}

// AutomaticKeepAliveClientMixin is used to keep the state of the widget when switching tabs
class _SearchResultsAccountsState extends State<SearchResultsAccounts> with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  bool _error = false;
  bool _hasMore = true;
  int _offset = 0;
  List<PublicAccountResponse> _accounts = [];

  void _load() async {
    String token = (await AccountCache.getToken())!;

    var response = await Api.v1.accounts.search(token, query: widget.query, offset: _offset);

    if (!response.ok) {
      _error = true;
    } else {
      _error = false;
      _accounts.addAll(response.data!);

      if (response.data!.length < 10) {
        _hasMore = false;
      }
    }

    _loading = false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        if (_loading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CrossPlatformLoader(),
            ),
          ),
        if (_error && !_loading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(l10n.somethingWentWrong),
              ),
            ),
          ),
        if (!_loading && !_error)
          SliverList.builder(
            itemCount: _accounts.length,
            itemBuilder: (context, index) {
              if (index == _accounts.length - 1 && _hasMore) {
                _offset += 10;
                _load();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2, horizontal: Sizing.horizontalPadding),
                child: _SearchResultsAccount(account: _accounts[index]),
              );
            },
          ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding,))
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _SearchResultsAccount extends StatefulWidget {
  final PublicAccountResponse account;

  const _SearchResultsAccount({Key? key, required this.account}) : super(key: key);

  @override
  State<_SearchResultsAccount> createState() => _SearchResultsAccountState();
}

class _SearchResultsAccountState extends State<_SearchResultsAccount> {
  late PublicAccountResponse _account;

  @override
  void initState() {
    super.initState();

    _account = widget.account;
  }

  void _openAccount() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          UUID: _account.UUID,
          username: _account.username,
          account: _account,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Touchable(
          onTap: _openAccount,
          child: SizedBox(
            width: 36,
            height: 36,
            child: ProfilePictureDisplay(size: 36, iconSize: 20, profilePicture: _account.profile.profilePicture)
          ),
        ),
        const SizedBox(width: 12,),
        Expanded(
          child: Touchable(
            onTap: _openAccount,
            child: Text(
              "@${_account.username}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),

        if (_account.verified)
          const SizedBox(width: 4,),
        if (_account.verified)
          const Icon(Icons.verified, size: 16, color: Colors.blue,),

        if (!_account.isMe)
          FeedSlimButton(
            onPressed: () async {
              String token = (await AccountCache.getToken())!;

              bool res = false;

              if (_account.isFollowing) {
                res = await Api.v1.accounts.unfollow(token, _account.UUID);

                if (res) {
                  SnackbarPresets.show(context, text: l10n.successfullyUnfollowed);
                }
              } else {
                res = await Api.v1.accounts.follow(token, _account.UUID);

                if (res) {
                  SnackbarPresets.show(context, text: l10n.successfullyFollowed);
                }
              }

              if (res) {
                setState(() {
                  _account.isFollowing = !_account.isFollowing;
                });
              }

              else {
                SnackbarPresets.error(context, l10n.somethingWentWrong);
              }
            },
            child: _account.isFollowing ? Text(l10n.unfollow) : Text(l10n.follow),
          )
      ],
    );
  }
}
