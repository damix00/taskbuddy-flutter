import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_tags_response.dart';

class CategoryTags {
  final int id;
  final Map<String, String> translations;
  final List<Tag> tags;

  const CategoryTags({required this.id, required this.translations, required this.tags});
}

class Category {
  final int id;
  final Map<String, String> translations;

  const Category({required this.id, required this.translations});
}

class Tag {
  final int id;
  final int category;
  final Map<String, String> translations;

  const Tag({required this.id, required this.category, required this.translations});
}

class TagModel extends ChangeNotifier {
  bool _isLoading = true;

  List<Category> _categories = [];
  List<Tag> _tags = [];

  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;

  set categories(List<Category> categories) {
    _categories = categories;

    notifyListeners();
  }

  set tags(List<Tag> tags) {
    _tags = tags;

    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;

    notifyListeners();
  }

  void saveResponse(PostTagsResponse response) {
    categories = response.categories.map((category) => Category(id: category.id, translations: category.translations)).toList();
    tags = response.categories.expand((category) => category.tags.map((tag) => Tag(id: tag.id, category: tag.category, translations: tag.translations))).toList();

    isLoading = false;
  }
}