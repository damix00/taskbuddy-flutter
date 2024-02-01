import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';

class PostResponse {
  PublicAccountResponse user;
  String UUID;
  String title;
  String description;
  PostType jobType;
  double price;
  String locationText;
  double locationLat;
  double locationLon;
  List<int> tags;
  List<String> media;
  DateTime createdAt;
  DateTime startDate;
  DateTime endDate;
  int status;
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

  void update(PostResultsResponse response) {
    this.title = response.title;
    this.description = response.description;
    this.jobType = response.jobType;
    this.price = response.price;
    this.locationText = response.locationText;
    this.locationLat = response.locationLat;
    this.locationLon = response.locationLon;
    this.tags = response.tags;
    this.media = response.media;
    this.startDate = response.startDate;
    this.endDate = response.endDate;
    this.isRemote = response.isRemote;
    this.isUrgent = response.isUrgent;
    this.isReserved = response.isReserved;
    this.status = response.status;
  }
}