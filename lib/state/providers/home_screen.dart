import 'package:flutter/material.dart';
import 'package:taskbuddy/state/providers/tags.dart';

enum HomeScreenType {
  suggested, following
}

enum PostLocationType {
  all, local, remote
}

enum UrgencyType {
  all, urgent, notUrgent
}

class HomeScreenModel extends ChangeNotifier {
  String _sessionUuid = '';
  List<Tag> _filteredTags = [];
  HomeScreenType _type = HomeScreenType.suggested;
  PostLocationType _postLocationType = PostLocationType.all;
  UrgencyType _urgencyType = UrgencyType.all;
  
  String get sessionUuid => _sessionUuid;
  List<Tag> get filteredTags => _filteredTags;
  HomeScreenType get type => _type;
  PostLocationType get postLocationType => _postLocationType;
  UrgencyType get urgencyType => _urgencyType;
  
  set sessionUuid(String value) {
    _sessionUuid = value;
    notifyListeners();
  }

  set filteredTags(List<Tag> value) {
    _filteredTags = value;
    notifyListeners();
  }

  set type(HomeScreenType value) {
    _type = value;
    notifyListeners();
  }

  set postLocationType(PostLocationType value) {
    _postLocationType = value;
    notifyListeners();
  }

  set urgencyType(UrgencyType value) {
    _urgencyType = value;
    notifyListeners();
  }
}