import 'package:taskbuddy/api/v1/accounts/accounts.dart';
import 'package:taskbuddy/api/v1/channels/channels.dart';
import 'package:taskbuddy/api/v1/posts/posts.dart';
import 'package:taskbuddy/api/v1/reviews/reviews.dart';
import 'package:taskbuddy/api/v1/sessions/sessions.dart';

class V1 {
  Accounts get accounts => Accounts();
  Posts get posts => Posts();
  Channels get channels => Channels();
  Sessions get sessions => Sessions();
  Reviews get reviews => Reviews();
}
