import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/search_history_cache.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/search_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _value = '';

  @override
  void initState() {
    super.initState();

    _value = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: SearchInput(
          initialValue: widget.query,
          hintText: l10n.search,
          fillColor: Theme.of(context).colorScheme.surface,
          borderRadius: 0,
          enabled: true,
          showIcon: false,
          onSearch: () async {
            if (_value.isEmpty || _value == widget.query) {
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
        )
      ),
      body: _SearchResults(query: widget.query)
    );
  }
}

class _SearchResults extends StatefulWidget {
  final String query;

  const _SearchResults({Key? key, required this.query}) : super(key: key);

  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  bool _loadingAccounts = true;
  bool _loadingPosts = true;
  List<PublicAccountResponse> _accounts = [];
  List<PostResultsResponse> _posts = [];

  Future<void> _loadAccounts() async {
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: l10n.accounts,
              ),
              Tab(
                text: l10n.listings,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Text('Accounts'),
                Text('Listings'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
