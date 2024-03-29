import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/sessions/session_response.dart';
import 'package:taskbuddy/state/providers/tags.dart';

class SearchFilterModel extends ChangeNotifier {
  List<Tag> _filteredTags = [];
  int _postLocationType = LocationType.ALL;
  int _urgencyType = UrgencyType.ALL;
  
  List<Tag> get filteredTags => _filteredTags;
  int get postLocationType => _postLocationType;
  int get urgencyType => _urgencyType;

  set filteredTags(List<Tag> value) {
    _filteredTags = value;
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

  void setData(int postLocationType, int urgencyType, List<Tag> tags) {
    _postLocationType = postLocationType;
    _urgencyType = urgencyType;
    _filteredTags = tags;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void clear() {
    _postLocationType = LocationType.ALL;
    _urgencyType = UrgencyType.ALL;
    _filteredTags = [];
    notifyListeners();
  }
}
