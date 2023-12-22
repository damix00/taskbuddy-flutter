import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:reorderables/reorderables.dart';
import 'dart:math' as math;

class CreatePostMediaEdit extends StatefulWidget {
  final List<XFile> items;
  final Function(List<XFile>) onItemsChanged;

  const CreatePostMediaEdit({
    Key? key,
    required this.items,
    required this.onItemsChanged,
  }) : super(key: key);

  @override
  State<CreatePostMediaEdit> createState() => _CreatePostMediaEditState();
}

class _CreatePostMediaEditState extends State<CreatePostMediaEdit> {
  List<XFile> _items = [];

  @override
  void initState() {
    super.initState();

    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.editMedia,
          style: Theme.of(context).textTheme.titleSmall
        )
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight + Sizing.horizontalPadding,),
            ),
            ReorderableSliverList(
              delegate: ReorderableSliverChildBuilderDelegate(
                (context, index) {
                  return _Item(
                    item: _items[index],
                    index: index,
                    itemCount: _items.length,
                    onRemoved: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  );
                },
                childCount: _items.length,
              ),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  var item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
                    child: Button(
                      child: Text(
                        l10n.done,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                        )
                      ),
                      onPressed: () {
                        widget.onItemsChanged(_items);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding / 2,),
                ],
              ),
            )
          ]
        ),
      )
    );
  }
}

class _Item extends StatelessWidget {
  final XFile item;
  final int index;
  final VoidCallback onRemoved;
  final int itemCount;

  const _Item({
    required this.item,
    required this.index,
    required this.onRemoved,
    required this.itemCount,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.path),
      direction: DismissDirection.endToStart,
      background: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
      onDismissed: (direction) {
        onRemoved();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 200,
                  width: math.min(MediaQuery.of(context).size.width - Sizing.horizontalPadding * 2 - 56, 500),
                  child: Image.file(
                    File(item.path),
                    fit: BoxFit.cover,
                  ),
                ),
                Icon(
                  Icons.reorder,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ],
            ),
            if (index != itemCount - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            if (index == itemCount - 1)
              const SizedBox(height: Sizing.formSpacing,)
          ],
        ),
      ),
    );
  }
}
