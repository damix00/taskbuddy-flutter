import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

enum PostType {
  oneTime,
  partTime,
  fullTime,
}

class Tag {
  final String name;
  final String category;

  const Tag(this.name, this.category);
}

class CreatePostState {
  static PostType postType = PostType.oneTime;
  static String title = '';
  static String description = '';
  static LatLng? location;
  static String? locationName;
  static bool isRemote = true;
  static bool isUrgent = false;
  static double price = 0;
  static String currency = 'EUR';
  static double suggestionRadius = 10;
  static List<XFile> media = [];
  static DateTime? startDate;
  static DateTime? endDate;
  static List<Tag> tags = [];

  static void clear() {
    // Clear all the state
    postType = PostType.oneTime;
    title = '';
    description = '';
    location = null;
    locationName = null;
    isRemote = false;
    isUrgent = false;
    price = 0;
    currency = 'EUR';
    suggestionRadius = 0;
    media = [];
    startDate = null;
    endDate = null;
    tags = [];
  }
}