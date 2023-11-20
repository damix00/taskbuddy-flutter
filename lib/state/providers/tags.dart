import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});
}

class Tag {
  final int id;
  final int category;
  final String name;

  const Tag({required this.id, required this.category, required this.name});
}

class TagModel extends ChangeNotifier {
  List<Category> _categories = [
    Category(
      id: 1,
      name: 'home_services'
    ),
    Category(
      id: 2,
      name: 'technology_assistance'
    ),
    Category(
      id: 3,
      name: 'other'
    ),
  ];
  List<Tag> _tags = [
    Tag(
      id: 1,
      category: 1,
      name: 'cleaning'
    ),
    Tag(
      id: 2,
      category: 1,
      name: 'gardening'
    ),
    Tag(
      id: 50,
      category: 1,
      name: 'moving'
    ),
    Tag(
      id: 3,
      category: 1,
      name: 'plumbing'
    ),
    Tag(
      id: 4,
      category: 1,
      name: 'painting'
    ),
    Tag(
      id: 5,
      category: 1,
      name: 'appliance_repair'
    ),
    Tag(
      id: 6,
      category: 1,
      name: 'home_organization'
    ),
    Tag(
      id: 7,
      category: 2,
      name: 'computer_repair'
    ),
    Tag(
      id: 8,
      category: 2,
      name: 'phone_repair'
    ),
    Tag(
      id: 9,
      category: 2,
      name: 'software_installation'
    ),
    Tag(
      id: 10,
      category: 2,
      name: 'networking'
    ),
    Tag(
      id: 11,
      category: 3,
      name: 'miscellaneous'
    ),
    Tag(
      id: 12,
      category: 3,
      name: 'general_assistance'
    ),
    Tag(
      id: 13,
      category: 3,
      name: 'custom'
    ),
  ];

  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;

  set categories(List<Category> categories) {
    _categories = categories;

    notifyListeners();
  }

  set tags(List<Tag> tags) {
    _tags = tags;

    notifyListeners();
  }
}