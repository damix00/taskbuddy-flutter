import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/search_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';

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
        child: Hero(
          tag: 'search',
          child: Material(
            child: SearchInput(
              hintText: l10n.search,
              fillColor: Theme.of(context).colorScheme.surface,
              borderRadius: 0,
              enabled: true,
              onTap: () {
              },
              onChanged: (String value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          )
        )
      ),
      body: const Center(
        child: Text('Search'),
      ),
    );
  }
}
