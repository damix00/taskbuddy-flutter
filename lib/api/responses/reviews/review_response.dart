import 'package:taskbuddy/api/responses/account/public_account_response.dart';

class ReviewType {
  static const int EMPLOYER = 0;
  static const int EMPLOYEE = 1;
}

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
  int type;

  ReviewResponse({
    required this.UUID,
    required this.rating,
    required this.title,
    required this.description,
    required this.postTitle,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.ratingForUUID,
    required this.type
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      UUID: json['uuid'],
      rating: double.parse(json['rating'].toString()),
      title: json['title'],
      description: json['description'],
      postTitle: json['post_title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: PublicAccountResponse.fromJson(json['user']),
      ratingForUUID: json['rating_for_uuid'],
      type: int.parse(json['type'].toString())
    );
  }
}