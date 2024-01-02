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
      int? requestType,
    }
  ) async {
    var data = {
      'content': message,
    };

    if (requestType != null) {
      data['request_type'] = requestType.toString();
    }

    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUUID)}/messages/send",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      },
      data: data,
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
}