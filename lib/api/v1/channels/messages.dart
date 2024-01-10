import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class Messages {
  Future<ApiResponse<MessageResponse?>> sendMessage(
    String token,
    {
      required String channelUUID,
      required String message,
    }
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUUID)}/messages/send",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      },
      data: {
        'content': message,
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: response.response!.statusCode! == 200,
      data: MessageResponse.fromJson(response.response!.data["message"]),
      response: response.response,
    );
  }

  Future<ApiResponse<List<MessageResponse>>> getMessages(
    String token,
    String channelUuid,
    int offset
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/messages?offset=$offset",
      method: "GET",
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    List<MessageResponse> messages = [];

    for (var message in response.response!.data["messages"]) {
      messages.add(MessageResponse.fromJson(message));
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: true,
      data: messages,
      response: response.response,
    );
  }

  Future<bool> deleteMessage(
    String token,
    String channelUuid,
    String messageUuid
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/messages/${Uri.encodeComponent(messageUuid)}",
      method: "DELETE",
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return false;
    }

    return true;
  }

  Future<bool> updateMessageStatus(
    String token,
    String channelUuid,
    String messageUuid,
    int status
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/messages/${Uri.encodeComponent(messageUuid)}/status?action=${status == 1 ? "accept" : "reject"}",
      method: "PATCH",
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return false;
    }

    return true;
  }
}