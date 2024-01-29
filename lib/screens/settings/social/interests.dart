import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({Key? key}) : super(key: key);

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  bool _loading = true;
  List<int> _interests = [];
  int _offset = 0;
  bool _hasMore = true;

  Future<void> _loadInterests() async {
    if (!_hasMore) {
      return;
    }

    String token = (await AccountCache.getToken())!;
    
    var response = await Api.v1.accounts.meRoute.getInterests(token, offset: _offset);

    if (response.isEmpty) {
      _hasMore = false;
    }

    _offset += response.length;

    setState(() {
      _interests = response;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    _loadInterests();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.interests,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<TagModel>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: _interests.length + (_loading ? 1 : 0) + 1 + ((_interests.isEmpty && !_loading) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizing.horizontalPadding,
                    vertical: 12
                  ),
                  child: Text(
                    l10n.interestsPageDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              }

              index--;

              if (index == _interests.length && _loading) {
                return const CrossPlatformLoader();
              }

              if (_interests.isEmpty && !_loading) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: Sizing.horizontalPadding,
                    right: Sizing.horizontalPadding,
                    top: 10
                  ),
                  child: Text(
                    l10n.noInterests,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizing.horizontalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        value.getCategoryName(_interests[index], Locale(AppLocalizations.of(context)!.localeName))
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        String token = (await AccountCache.getToken())!;

                        await Api.v1.accounts.meRoute.deleteInterest(token, _interests[index]);

                        setState(() {
                          _interests.removeAt(index);
                        });
                      },
                    )
                  ],
                )
              );
            }
          );
        }
      )
    );
  }
}
