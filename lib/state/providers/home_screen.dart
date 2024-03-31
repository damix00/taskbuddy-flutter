import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/sessions/session_response.dart';
import 'package:taskbuddy/state/providers/tags.dart';

// This model contains the state for the home screen
// It contains the filters that are applied to the posts
class HomeScreenModel extends ChangeNotifier {
  List<Tag> _filteredTags = [];
  int _type = SessionType.ALL;
  int _postLocationType = LocationType.ALL;
  int _urgencyType = UrgencyType.ALL;
  int? _minPrice, _maxPrice;
  
  List<Tag> get filteredTags => _filteredTags;
  int get type => _type;
  int get postLocationType => _postLocationType;
  int get urgencyType => _urgencyType;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
  
  set filteredTags(List<Tag> value) {
    _filteredTags = value;
    notifyListeners();
  }

  set type(int value) {
    _type = value;
    notifyListeners();
  }

  set postLocationType(int value) {
    _postLocationType = value;
    notifyListeners();
  }

  set urgencyType(int value) {
    _urgencyType = value;
    notifyListeners();
  }

  set minPrice(int? value) {
    _minPrice = value;
    notifyListeners();
  }

  set maxPrice(int? value) {
    _maxPrice = value;
    notifyListeners();
  }

  void setData(int type, int postLocationType, int urgencyType, List<Tag> tags, {int? minPrice, int? maxPrice}) {
    _type = type;
    _postLocationType = postLocationType;
    _urgencyType = urgencyType;
    _filteredTags = tags;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}