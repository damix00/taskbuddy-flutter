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
  num locationLat;
  num locationLon;
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
      bio: json['bio'],
      profilePicture: json['profile_picture'] ?? '',
      ratingEmployer: json['rating_employer'],
      ratingEmployee: json['rating_employee'],
      cancelledEmployer: json['cancelled_employer'],
      cancelledEmployee: json['cancelled_employee'],
      completedEmployer: json['completed_employer'],
      completedEmployee: json['completed_employee'],
      followers: json['followers'],
      following: json['following'],
      posts: json['posts'],
      locationText: json['location_text'],
      locationLat: json['location_lat'],
      locationLon: json['location_lon'],
      isPrivate: json['is_private'],
    );
  }
}