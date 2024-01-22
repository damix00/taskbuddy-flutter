import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/content/tag_picker.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/tag_widget.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return BlurParent(
      noBlurColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HomeScreenModel>(
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          l10n.filter, 
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24,),
                      DropdownMenu(
                        label: Text(l10n.urgency),
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        initialSelection: model.urgencyType,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: UrgencyType.all,
                            label: l10n.all,
                          ),
                          DropdownMenuEntry(
                            value: UrgencyType.urgent,
                            label: l10n.urgentText,
                          ),
                          DropdownMenuEntry(
                            value: UrgencyType.notUrgent,
                            label: l10n.notUrgent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                      DropdownMenu(
                        label: Text(l10n.location),
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        initialSelection: model.postLocationType,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: PostLocationType.all,
                            label: l10n.all,
                          ),
                          DropdownMenuEntry(
                            value: PostLocationType.local,
                            label: l10n.local,
                          ),
                          DropdownMenuEntry(
                            value: PostLocationType.remote,
                            label: l10n.remote,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                l10n.tags,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (model.filteredTags.isNotEmpty)
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).colorScheme.onBackground
                                ),
                                onPressed: () {
                                  model.filteredTags = [];
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.onBackground
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      child: Stack(
                                        children: [
                                          SingleChildScrollView(
                                            child: BlurParent(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 16
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                                  child: TagPicker(
                                                    selectable: true,
                                                    selectedTags: model.filteredTags,
                                                    onSelect: (tags) {
                                                      model.filteredTags = tags;
                                                    },
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Theme.of(context).colorScheme.onSurfaceVariant
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    );
                                  }
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      if (model.filteredTags.isEmpty)
                        Text(
                          l10n.all,
                          style: Theme.of(context).textTheme.labelMedium
                        ),

                      if (model.filteredTags.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: model.filteredTags.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TagWidget(
                                  tag: model.filteredTags[index],
                                  onSelect: (v) {},
                                  isSelectable: false,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }
            ),
            const SizedBox(height: 24,),
            Button(
              child: const ButtonText('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}