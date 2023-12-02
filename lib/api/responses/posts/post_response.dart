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
  final List<Tag> tags;
  final List<String> media;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;

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
  });

  // Factory method to create a PostResponse from JSON data
  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      user: PublicAccountResponse.fromJson(json['user']),
      UUID: json['uuid'],
      title: json['title'],
      description: json['description'],
      jobType: PostType.values[json['job_type']],
      price: json['price'],
      locationText: json['location_text'],
      locationLat: json['location_lat'],
      locationLon: json['location_lon'],
      tags: (json['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
      media: (json['media'] as List).map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['created_at']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}