import 'package:taskbuddy/api/v1/accounts/me/posts/posts.dart';
import 'package:taskbuddy/api/v1/accounts/me/profile/profile.dart';

class MeRoute {
  ProfileRoute get profile => ProfileRoute();
  MyPostsRoute get posts => MyPostsRoute();
}