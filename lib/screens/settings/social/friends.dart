import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/tiles/account_tile.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool _loading = true;
  List<PublicAccountResponse> _friends = [];
  int _offset = 0;
  bool _hasMore = true;

  Future<void> _loadFriends() async {
    if (!_hasMore) {
      return;
    }

    String token = (await AccountCache.getToken())!;
    
    var response = await Api.v1.accounts.meRoute.getFriends(token, offset: _offset);

    if (response.isEmpty) {
      _hasMore = false;
    }

    _offset += response.length;

    setState(() {
      _friends = response;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    _loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.friends,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: ListView.builder(
        itemCount: _friends.length + (_loading ? 1 : 0) + 1 + ((_friends.isEmpty && !_loading) ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: Sizing.horizontalPadding,
                right: Sizing.horizontalPadding,
                top: 12
              ),
              child: Text(
                l10n.friendsPageDesc,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          }

          index--;

          if (index == _friends.length && _loading) {
            return const CrossPlatformLoader();
          }

          if (_friends.isEmpty && !_loading) {
            return Padding(
              padding: const EdgeInsets.only(
                left: Sizing.horizontalPadding,
                right: Sizing.horizontalPadding,
                top: Sizing.horizontalPadding,
              ),
              child: Text(
                l10n.noFriends,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(
              left: Sizing.horizontalPadding,
              right: Sizing.horizontalPadding,
              top: Sizing.horizontalPadding,
            ),
            child: AccountTile(
              account: _friends[index],
              blocked: false,
              trailing: FeedSlimButton(
                child: Text(
                  l10n.unfollow,
                ),
                onPressed: () async {
                  String token = (await AccountCache.getToken())!;

                  LoadingOverlay.showLoader(context);

                  var res = await Api.v1.accounts.unfollow(token, _friends[index].UUID);

                  LoadingOverlay.hideLoader(context);

                  if (!res) {
                    return;
                  }

                  if (index == _friends.length - 1 && _hasMore && !_loading) {
                    _loadFriends();
                  }

                  setState(() {
                    _friends.removeAt(index);
                  });
                },
              )
            ),
          );
        }
      )
    );
  }
}
