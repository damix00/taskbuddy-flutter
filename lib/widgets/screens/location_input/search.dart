import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

class SearchResultData {
  final String name;
  final String? address;
  final LatLng position;

  SearchResultData({
    required this.name,
    required this.position,
    this.address
  });

}

class SearchResults extends StatefulWidget {
  final String query;
  final Function(SearchResultData) onResultSelected;

  const SearchResults({
    required this.query,
    required this.onResultSelected,
    Key? key
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<SearchResultData> _results = [];
  bool _loading = false;

  void _fetchResults() async {
    // Uses the OpenStreetMap Nominatim API
    var url = 'https://nominatim.openstreetmap.org/search?q=${widget.query}&format=json&limit=20';

    setState(() {
      _loading = true;
    });

    var data = await Requests.fetchEndpoint(url);

    if (data!.timedOut) {
      setState(() {
        _loading = false;
        _results = [];
        SnackbarPresets.networkError(context);
      });

      return;
    }

    var json = data.response!.data;

    if (json is List) {
      setState(() {
        _loading = false;
        _results = json.map((e) => SearchResultData(
          name: e['name'],
          address: e['display_name'],
          position: LatLng(double.parse(e['lat']), double.parse(e['lon']))
        )).toList();
      });
    }
    else {
      setState(() {
        _loading = false;
        _results = [];
      });
    }
  }

  // Get the results initially
  @override
  void initState() {
    super.initState();

    _fetchResults();
  }

  // Update results and when the query changes
  @override
  void didUpdateWidget(covariant SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query) {
      _fetchResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SizedBox(
            height: 24,
            width: 24,
            child: CupertinoActivityIndicator(
            ),
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            AppLocalizations.of(context)!.networkError,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: _results.length,
      itemBuilder: (ctx, i) {
        var result = _results[i];
    
        return SearchResult(
          result: result,
          index: i,
          isLast: i == _results.length - 1,
          onTap: () {
            widget.onResultSelected(result);
          },
        );
      },
    );
  }
}

class SearchResult extends StatelessWidget {
  final SearchResultData result;
  final VoidCallback onTap;
  final int index;
  final bool isLast;

  const SearchResult({
    required this.result,
    required this.onTap,
    required this.index,
    required this.isLast,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: index == 0 ? 16 : 0,
          bottom: isLast ? MediaQuery.of(context).padding.bottom + 16 : 0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (result.address != null)
              Text(
                result.address!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2))
          ],
        ),
      ),
    );
  }
}