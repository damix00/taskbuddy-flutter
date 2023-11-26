import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/tag_widget.dart';

class RenderedTag {
  Tag tag;
  bool selected;

  RenderedTag({required this.tag, this.selected = false});
}

class RenderedCategory {
  int id;
  String name;
  List<RenderedTag> tags;

  RenderedCategory({required this.id, required this.name, required this.tags});
}

class TagPicker extends StatefulWidget {
  final List<Tag>? selectedTags;
  final Function(List<Tag>)? onSelect;
  final bool selectable;
  final int? max;

  const TagPicker({
    Key? key,
    this.selectable = true,
    this.max,
    this.selectedTags,
    this.onSelect
  }) : super(key: key);

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<RenderedCategory> _renderedCategories = [];
  List<Tag> _selectedTags = [];

  List<RenderedCategory> _buildCategories(List<Tag> tags, List<Category> categories) {
    List<RenderedCategory> renderedCategories = [];

    categories.forEach((category) {
      List<RenderedTag> renderedTags = [];

      tags.forEach((tag) {
        if (tag.category == category.id) {
          renderedTags.add(RenderedTag(tag: tag));
        }
      });

      renderedCategories.add(RenderedCategory(
        id: category.id,
        name: category.translations[Localizations.localeOf(context).languageCode.toLowerCase()] ?? category.translations['en']!,
        tags: renderedTags,
      ));
    });

    return renderedCategories;
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectedTags != null) {
      _selectedTags = widget.selectedTags!;
    }
  }

  List<Widget> _build() {
    List<Widget> r = [];

    for (var index = 0; index < _renderedCategories.length; index++) {
      r.add(Text(_renderedCategories[index].name, style: Theme.of(context).textTheme.titleSmall));
      r.add(const SizedBox(height: 8));
      r.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var tag in _renderedCategories[index].tags)
              TagWidget(
                tag: tag.tag,
                onSelect: (v) {
                  if (widget.selectable) {
                    setState(() {
                      if (v) {
                        if (widget.max != null && _selectedTags.length >= widget.max!) {
                          return;
                        }

                        _selectedTags.add(tag.tag);
                      } else {
                        _selectedTags.remove(tag.tag);
                      }
                    });

                    if (widget.onSelect != null) {
                      widget.onSelect!(_selectedTags);
                    }
                  }
                },
                selected: _selectedTags.contains(tag.tag),
              ),
          ],
        )
      );
      r.add(const SizedBox(height: 16));
    }

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TagModel>(
      builder: (ctx, value, child) {
        _renderedCategories = _buildCategories(value.tags, value.categories);

        if (value.isLoading) {
          return const CrossPlatformLoader();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _build()
        );
      }
    );
  }
}
