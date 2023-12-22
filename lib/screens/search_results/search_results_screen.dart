import 'package:flutter/material.dart';

class SearchResultsArguments {
  final String query;

  SearchResultsArguments({
    required this.query
  });
}

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchResultsArguments args = ModalRoute.of(context)!.settings.arguments as SearchResultsArguments;

    return const Scaffold(
      body: Center(child: Text('SearchResultsScreen')),
    );
  }
}
