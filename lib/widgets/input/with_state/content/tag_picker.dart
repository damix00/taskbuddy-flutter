import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/tags.dart';
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
  final bool selectable;

  const TagPicker({Key? key, this.selectable = true}) : super(key: key);

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<RenderedCategory> _renderedCategories = [];

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
        name: category.name,
        tags: renderedTags,
      ));
    });

    return renderedCategories;
  }

  @override
  void initState() {
    super.initState();

    var model = Provider.of<TagModel>(context, listen: false);

    _renderedCategories = _buildCategories(model.tags, model.categories);
  }

  List<Widget> _build() {
    List<Widget> r = [];

    for (var index = 0; index < _renderedCategories.length; index++) {
      r.add(Text(_renderedCategories[index].name));
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
                      tag.selected = v;
                    });
                  }
                },
                selected: tag.selected,
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _build()
        );
      }
    );
  }
}
