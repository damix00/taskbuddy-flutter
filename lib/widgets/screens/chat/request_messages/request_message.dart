import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/app_outdated.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/requests/deal_request.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/requests/finish_request.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/requests/negotiations/date_negotiate_request.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/requests/negotiations/price_negotiate_request.dart';

class RequestMessageWidget extends StatelessWidget {
  final MessageResponse message;

  const RequestMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.request == null) {
      return const AppOutdated();
    }

    if (message.request!.type == RequestMessageType.DEAL) {
      return DealRequestMessage(
        message: message,
      );
    }

    if (message.request!.type == RequestMessageType.PRICE) {
      return PriceNegotiateRequest(
        message: message
      );
    }

    if (message.request!.type == RequestMessageType.DATE) {
      return DateNegotiateRequest(
        message: message
      );
    }

    if (message.request!.type == RequestMessageType.COMPLETE) {
      return FinishRequestMessage(
        message: message
      );
    }

    return const AppOutdated();
  }
}
