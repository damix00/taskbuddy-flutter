import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';

class PostResultsUser {
  String UUID;
  String username;
  String firstName;
  String lastName;
  bool isFollowing;
  bool isMe;
  bool hasPremium;
  bool verified;
  String profilePicture;

  PostResultsUser({
    required this.UUID,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isFollowing,
    required this.isMe,
    required this.hasPremium,
    required this.verified,
    required this.profilePicture,
  });

  factory PostResultsUser.fromJson(Map<String, dynamic> json) {
    return PostResultsUser(
      UUID: json['uuid'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isFollowing: json['is_following'],
      isMe: json['is_me'],
      hasPremium: json['has_premium'],
      verified: json['verified'],
      profilePicture: json['profile']?['profile_picture'] ?? "",
    );
  }

  factory PostResultsUser.fromAccountResponse(PublicAccountResponse response) {
    return PostResultsUser(
      UUID: response.UUID,
      username: response.username,
      firstName: response.firstName,
      lastName: response.lastName,
      isFollowing: response.isFollowing,
      isMe: response.isMe,
      hasPremium: response.hasPremium,
      verified: response.verified,
      profilePicture: response.profile.profilePicture,
    );
  }
}

class PostResultsResponse {
  final PostResultsUser user;
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

  PostResultsResponse({
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

  // Factory method to create a PostResponse from JSON data
  factory PostResultsResponse.fromJson(Map<String, dynamic> json) {
    List<String> media = [];

    for (int i = 0; i < json['media'].length; i++) {
      media.add(json['media'][i]['media']); // Dart is weird
    }

    return PostResultsResponse(
      user: PostResultsUser.fromJson(json['user']),
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
      status: json['status'] ?? 0
    );
  }

  factory PostResultsResponse.fromPostResponse(PostResponse response) {
    return PostResultsResponse(
      user: PostResultsUser.fromAccountResponse(response.user),
      UUID: response.UUID,
      title: response.title,
      description: response.description,
      jobType: response.jobType,
      price: response.price,
      locationText: response.locationText,
      locationLat: response.locationLat,
      locationLon: response.locationLon,
      tags: response.tags,
      media: response.media,
      createdAt: response.createdAt,
      startDate: response.startDate,
      endDate: response.endDate,
      likes: response.likes,
      comments: response.comments,
      shares: response.shares,
      bookmarks: response.bookmarks,
      impressions: response.impressions,
      isRemote: response.isRemote,
      isUrgent: response.isUrgent,
      isLiked: response.isLiked,
      isBookmarked: response.isBookmarked,
      isReserved: response.isReserved,
      status: response.status
    );
  }
}