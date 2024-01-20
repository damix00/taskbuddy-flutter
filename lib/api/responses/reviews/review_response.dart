import 'package:taskbuddy/api/responses/account/public_account_response.dart';

class ReviewResponse {
  String UUID;
  double rating;
  String title;
  String description;
  String postTitle;
  DateTime createdAt;
  DateTime updatedAt;
  PublicAccountResponse user;
  String ratingForUUID;

  ReviewResponse({
    required this.UUID,
    required this.rating,
    required this.title,
    required this.description,
    required this.postTitle,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.ratingForUUID
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      UUID: json['uuid'],
      rating: json['rating'],
      title: json['title'],
      description: json['description'],
      postTitle: json['post_title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: PublicAccountResponse.fromJson(json['user']),
      ratingForUUID: json['ratingForUUID']
    );
  }
}