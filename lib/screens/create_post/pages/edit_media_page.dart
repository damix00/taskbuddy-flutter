import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:reorderables/reorderables.dart';

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
      body: CustomScrollView(
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
                  onRemoved: () {
                    setState(() {
                      _items.removeAt(index);
                      widget.onItemsChanged(_items);
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
        
                widget.onItemsChanged(_items);
              });
            },
          ),
        ]
      )
    );
  }
}

class _Item extends StatelessWidget {
  final XFile item;
  final int index;
  final VoidCallback onRemoved;

  const _Item({
    required this.item,
    required this.index,
    required this.onRemoved,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Dismissible(
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
          child: Row(
            children: [
              Expanded(
                child: Image.file(
                  File(item.path),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.reorder,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
