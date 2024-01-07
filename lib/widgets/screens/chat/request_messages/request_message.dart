import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/app_outdated.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/deal_request.dart';

class RequestMessageWidget extends StatelessWidget {
  final int type;
  final int status;

  const RequestMessageWidget({
    Key? key,
    required this.type,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == RequestMessageType.DEAL) {
      return DealRequestMessage(status: status);
    }

    return const AppOutdated();
  }
}