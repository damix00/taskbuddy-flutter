import 'dart:convert';

import 'package:taskbuddy/state/static/create_post_state.dart';

class PostStatus {
  static const int OPEN = 0;
  static const int CLOSED = 1;
  static const int RESERVED = 2;
  static const int COMPLETED = 3;
  static const int CANCELLED = 4;
  static const int EXPIRED = 5;
}

class PostOnlyResponse {
  final String UUID;
  final String title;
  final String description;
  final PostType jobType;
  final double price;
  final String locationText;
  final double locationLat;
  final double locationLon;
  final List<int> tags;
  final List<String> media;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  int likes;
  int comments;
  int shares;
  int bookmarks;
  int impressions;
  bool isRemote;
  bool isUrgent;
  bool isLiked;
  bool isBookmarked;
  bool isReserved = false;
  int status;

  PostOnlyResponse({
    required this.UUID,
    required this.title,
    required this.description,
    required this.jobType,
    required this.price,
    required this.locationText,
    required this.locationLat,
    required this.locationLon,
    required this.tags,
    required this.media,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.isRemote,
    required this.isUrgent,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.bookmarks = 0,
    this.impressions = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.isReserved = false,
    this.status = 0
  });

  factory PostOnlyResponse.fromJson(Map<String, dynamic> json) {
    List<String> media = [];

    for (int i = 0; i < json['media'].length; i++) {
      media.add(json['media'][i]['media']); // Dart is weird
    }

    return PostOnlyResponse(
      UUID: json['uuid'],
      title: json['title'],
      description: json['description'],
      jobType: PostType.values[json['job_type']],
      price: json['price'].toDouble(),
      locationText: json['display_location']?['location_name'] ?? '',
      locationLat: json['display_location']?['lat']?.toDouble() ?? 1000,
      locationLon: json['display_location']?['lon']?.toDouble() ?? 1000,
      tags: (json['tags'] as List<dynamic>).map((e) => int.parse(e.toString())).toList(), // Dart being weird again...
      media: media,
      createdAt: DateTime.parse(json['created_at']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      likes: json['analytics']['likes'],
      comments: json['analytics']['comments'],
      shares: json['analytics']['shares'],
      bookmarks: json['analytics']['bookmarks'],
      impressions: json['analytics']['impressions'],
      isRemote: json['is_remote'] ?? false,
      isUrgent: json['is_urgent'] ?? false,
      isLiked: json['liked'] ?? false,
      isBookmarked: json['bookmarked'] ?? false,
      isReserved: json['reserved'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  String toJson() {
    return jsonEncode({
      "uuid": UUID,
      "title": title,
      "description": description,
      "job_type": jobType.index,
      "price": price,
      "display_location": {
        "location_name": locationText,
        "lat": locationLat,
        "lon": locationLon,
      },
      "tags": tags,
      "media": media,
      "created_at": createdAt.toIso8601String(),
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "analytics": {
        "likes": likes,
        "comments": comments,
        "shares": shares,
        "bookmarks": bookmarks,
        "impressions": impressions,
      },
      "is_remote": isRemote,
      "is_urgent": isUrgent,
      "liked": isLiked,
      "bookmarked": isBookmarked,
      "reserved": isReserved,
      "status": status,
    });
  }
}