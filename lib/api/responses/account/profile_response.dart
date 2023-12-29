import 'dart:convert';

class ProfileResponse {
  String bio;
  String profilePicture;
  num ratingEmployer;
  num ratingEmployee;
  int cancelledEmployer;
  int cancelledEmployee;
  int completedEmployer;
  int completedEmployee;
  int followers;
  int following;
  int posts;
  String locationText;
  num? locationLat;
  num? locationLon;
  bool isPrivate;

  ProfileResponse({
    required this.bio,
    required this.profilePicture,
    required this.ratingEmployer,
    required this.ratingEmployee,
    required this.cancelledEmployer,
    required this.cancelledEmployee,
    required this.completedEmployer,
    required this.completedEmployee,
    required this.followers,
    required this.following,
    required this.posts,
    required this.locationText,
    required this.locationLat,
    required this.locationLon,
    required this.isPrivate,
  });

  // Factory method to create a ProfileResponse from JSON data
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      bio: json['bio'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      ratingEmployer: json['rating_employer'] ?? 0,
      ratingEmployee: json['rating_employee'] ?? 0,
      cancelledEmployer: json['cancelled_employer'] ?? 0,
      cancelledEmployee: json['cancelled_employee'] ?? 0,
      completedEmployer: json['completed_employer'] ?? 0,
      completedEmployee: json['completed_employee'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      posts: json['posts'] ?? 0,
      locationText: json['location_text'] ?? '',
      locationLat: json['location_lat'] ?? 1000,
      locationLon: json['location_lon'] ?? 1000,
      isPrivate: json['is_private'] ?? false,
    );
  }

  String toJson() {
    return jsonEncode({
      "bio": bio,
      "profile_picture": profilePicture,
      "rating_employer": ratingEmployer,
      "rating_employee": ratingEmployee,
      "cancelled_employer": cancelledEmployer,
      "cancelled_employee": cancelledEmployee,
      "completed_employer": completedEmployer,
      "completed_employee": completedEmployee,
      "followers": followers,
      "following": following,
      "posts": posts,
      "location_text": locationText,
      "location_lat": locationLat,
      "location_lon": locationLon,
      "is_private": isPrivate,
    });
  }
}