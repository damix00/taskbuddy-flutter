import 'package:taskbuddy/api/v1/accounts/accounts.dart';
import 'package:taskbuddy/api/v1/channels/channels.dart';
import 'package:taskbuddy/api/v1/posts/posts.dart';

class V1 {
  Accounts get accounts => Accounts();
  Posts get posts => Posts();
  Channels get channels => Channels();
}
