import 'package:taskbuddy/state/providers/tags.dart';

class PostTagsResponse {
  final List<CategoryTags> categories;

  const PostTagsResponse({required this.categories});

  factory PostTagsResponse.fromJson(Map<String, dynamic> json) {
    List<CategoryTags> categories = [];

    for (Map<String, dynamic> category in json['categories']) {
      List<Tag> tags = [];

      for (Map<String, dynamic> tag in category['tags']) {
        tags.add(Tag(
          id: tag['tag_id'],
          category: tag['category_id'],
          translations: Map<String, String>.from(tag['translations']),
        ));
      }

      categories.add(CategoryTags(
        id: category['category_id'],
        translations: Map<String, String>.from(category['translations']),
        tags: tags,
      ));
    }

    return PostTagsResponse(
      categories: categories,
    );
  }
}