class UrgencyType {
  static const int ALL = 0;
  static const int NOT_URGENT = 1;
  static const int URGENT = 2;
}

class LocationType {
  static const int ALL = 0;
  static const int REMOTE = 1;
  static const int LOCAL = 2;
}

class SessionType {
  static const int ALL = 0;
  static const int FOLLOWING = 1;
}

class SessionFilters {
  int urgency;
  int location;
  List<int> tags;
  int type;

  SessionFilters({
    this.urgency = UrgencyType.ALL,
    this.location = LocationType.ALL,
    this.tags = const [],
    this.type = SessionType.ALL,
  });
}

class SessionResponse {
  int id;
  double? lat;
  double? lon;
  SessionFilters filters;
  DateTime createdAt;

  SessionResponse({
    required this.id,
    this.lat,
    this.lon,
    required this.filters,
    required this.createdAt,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      id: json['id'],
      lat: json['lat'] == null ? null : double.parse(json['lat'].toString()),
      lon: json['lon'] == null ? null : double.parse(json['lon'].toString()),
      filters: SessionFilters(
        urgency: json['filters']['urgency'],
        location: json['filters']['location'],
        tags: json['filters']['tags'].cast<int>(),
        type: json['filters']['type'],
      ),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}