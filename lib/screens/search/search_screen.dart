import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/cache/search_history_cache.dart';
import 'package:taskbuddy/screens/search/search_filters.dart';
import 'package:taskbuddy/screens/search/search_results_screen.dart';
import 'package:taskbuddy/state/providers/search_filters.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/search_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: 'search',
                child: Material(
                  child: SearchInput(
                    hintText: l10n.search,
                    fillColor: Theme.of(context).colorScheme.surface,
                    borderRadius: 0,
                    enabled: true,
                    showIcon: false,
                    onSearch: () async {
                      if (_value.isEmpty) {
                        return;
                      }
            
                      var history = await SearchHistoryCache.getHistory();
            
                      if (!history.contains(_value)) {
                        history.add(_value);
                        await SearchHistoryCache.setHistory(history);
                      }
            
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => SearchResultsScreen(query: _value)
                        )
                      );
                    },
                    onChanged: (String value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                )
              ),
            ),
            const SearchFilters()
          ],
        )
      ),
      body: const _SearchHistory()
    );
  }
}

class _SearchHistory extends StatefulWidget {
  const _SearchHistory({Key? key}) : super(key: key);

  @override
  State<_SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<_SearchHistory> {
  var _history = [];

  void _load() async {
    _history = await SearchHistoryCache.getHistory();

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
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      itemCount: _history.length + 1,
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizing.horizontalPadding / 2),
            child: Row(
              children: [
                Text(
                  l10n.searchHistory,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w900
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await SearchHistoryCache.setHistory([]);

                    _load();
                  },
                )
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: Sizing.horizontalPadding / 2),
          child: Touchable(
            child: Text(
              _history[index - 1],
              style: Theme.of(context).textTheme.bodyMedium
            ),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => SearchResultsScreen(query: _history[index - 1])
                )
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    SearchFilterModel model = Provider.of<SearchFilterModel>(context, listen: false);
    model.clear();

    super.dispose();
  }
}
