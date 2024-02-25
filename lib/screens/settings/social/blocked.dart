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

// Blocked users screen
// Shows the users that the user has blocked
class BlockedUsers extends StatefulWidget {
  const BlockedUsers({Key? key}) : super(key: key);

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  bool _loading = true;
  List<PublicAccountResponse> _blockedUsers = [];
  int _offset = 0;
  bool _hasMore = true;

  Future<void> _loadBlockedUsers() async {
    if (!_hasMore) {
      return;
    }

    String token = (await AccountCache.getToken())!;
    
    var response = await Api.v1.accounts.meRoute.getBlockedUsers(token, offset: _offset);

    if (response.isEmpty) {
      _hasMore = false;
    }

    _offset += response.length;

    setState(() {
      _blockedUsers.addAll(response);
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    _loadBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.blockedUsers,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: ListView.builder(
        itemCount: _blockedUsers.length + (_loading ? 1 : 0) + ((_blockedUsers.isEmpty && !_loading) ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _blockedUsers.length && _loading) {
            return const CrossPlatformLoader();
          }

          if (_blockedUsers.isEmpty && !_loading) {
            return Padding(
              padding: const EdgeInsets.only(
                left: Sizing.horizontalPadding,
                right: Sizing.horizontalPadding,
                top: Sizing.horizontalPadding,
              ),
              child: Text(
                l10n.noBlockedUsers,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (index == _blockedUsers.length - 1 && _hasMore && !_loading) {
            _loadBlockedUsers();
          }

          return Padding(
            padding: const EdgeInsets.only(
              left: Sizing.horizontalPadding,
              right: Sizing.horizontalPadding,
              top: Sizing.horizontalPadding,
            ),
            child: AccountTile(
              account: _blockedUsers[index],
              blocked: true,
              trailing: FeedSlimButton(
                child: Text(
                  l10n.unblock,
                ),
                onPressed: () async {
                  String token = (await AccountCache.getToken())!;

                  LoadingOverlay.showLoader(context);

                  var res = await Api.v1.accounts.unblock(token, _blockedUsers[index].UUID);

                  LoadingOverlay.hideLoader(context);

                  if (!res) {
                    return;
                  }

                  setState(() {
                    _blockedUsers.removeAt(index);
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
