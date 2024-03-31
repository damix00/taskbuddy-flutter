import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/home/filter_dialog.dart';
import 'package:taskbuddy/state/providers/search_filters.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Consumer<SearchFilterModel>(
        builder: (context, model, child) {
          return IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Theme.of(context).colorScheme.onSurface
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: FilterDialog(
                        filteredTags: model.filteredTags,
                        postLocationType: model.postLocationType,
                        urgencyType: model.urgencyType,
                        minPrice: model.minPrice,
                        maxPrice: model.maxPrice,
                        onFilter: (data) {
                          model.setData(
                            data.postLocationType,
                            data.urgencyType,
                            data.filteredTags,
                            minPrice: data.minPrice,
                            maxPrice: data.maxPrice
                          );
                        },
                      )
                    )
                  );
                }
              );
            },
          );
        }
      ),
    );
  }
}