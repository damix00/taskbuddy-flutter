import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/tiles/account_tile.dart';

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

              var account = _accounts[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2, horizontal: Sizing.horizontalPadding),
                child: AccountTile(
                  account: _accounts[index],
                  trailing: FeedSlimButton(
                    onPressed: () async {
                      String token = (await AccountCache.getToken())!;

                      bool res = false;

                      if (account.isFollowing) {
                        res = await Api.v1.accounts.unfollow(token, account.UUID);

                        if (res) {
                          SnackbarPresets.show(context, text: l10n.successfullyUnfollowed);
                        }
                      } else {
                        res = await Api.v1.accounts.follow(token, account.UUID);

                        if (res) {
                          SnackbarPresets.show(context, text: l10n.successfullyFollowed);
                        }
                      }

                      if (res) {
                        setState(() {
                          account.isFollowing = !account.isFollowing;
                        });
                      }

                      else {
                        SnackbarPresets.error(context, l10n.somethingWentWrong);
                      }
                    },
                    child: account.isFollowing ? Text(l10n.unfollow) : Text(l10n.follow),
                  ),
                ),
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
