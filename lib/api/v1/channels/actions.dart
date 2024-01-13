import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class Actions {
  Future<ApiResponse<MessageResponse?>> manageWorker(
    String token,
    String channelUuid,
    bool accept
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/actions/worker?verdict=${accept ? '1' : '0'}",
      method: "POST",
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

    if (!accept) {
      return ApiResponse(
        status: response.response!.statusCode!,
        message: 'OK',
        ok: response.response!.statusCode! == 200,
        data: null,
        response: response.response,
      );
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: response.response!.statusCode! == 200,
      data: MessageResponse.fromJson(response.response!.data["message"]),
      response: response.response,
    );
  }

  Future<bool> cancelJob(
    String token,
    String channelUuid,
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/actions/cancel",
      method: "POST",
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

  Future<ApiResponse<MessageResponse?>> negotiatePrice(
    String token,
    String channelUuid,
    double price
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/${Uri.encodeComponent(channelUuid)}/actions/negotiate/price",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      },
      data: {
        "price": price
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
}