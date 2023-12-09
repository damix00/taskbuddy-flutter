import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';

class PostResponse {
  final PublicAccountResponse user;
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
  final int likes;
  final int comments;
  final int shares;
  final int bookmarks;
  final int impressions;

  PostResponse({
    required this.user,
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
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.bookmarks = 0,
    this.impressions = 0,
  });

  // Factory method to create a PostResponse from JSON data
  factory PostResponse.fromJson(Map<String, dynamic> json) {
    List<String> media = [];

    for (int i = 0; i < json['media'].length; i++) {
      media.add(json['media'][i]['media']); // Dart is weird
    }

    return PostResponse(
      user: PublicAccountResponse.fromJson(json['user']),
      UUID: json['uuid'],
      title: json['title'],
      description: json['description'],
      jobType: PostType.values[json['job_type']],
      price: json['price'].toDouble(),
      locationText: json['display_location']['location_name'],
      locationLat: json['display_location']['lat'].toDouble(),
      locationLon: json['display_location']['lon'].toDouble(),
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
    );
  }
}