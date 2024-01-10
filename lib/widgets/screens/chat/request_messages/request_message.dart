import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/app_outdated.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/deal_request.dart';

class RequestMessageWidget extends StatelessWidget {
  final MessageRequest messageRequest;
  final MessageResponse message;

  const RequestMessageWidget({
    Key? key,
    required this.messageRequest,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messageRequest.type == RequestMessageType.DEAL) {
      return DealRequestMessage(
        status: messageRequest.status,
        message: message,
      );
    }

    return const AppOutdated();
  }
}
