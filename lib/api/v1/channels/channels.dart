import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class Channels {
  Future<ApiResponse<ChannelResponse?>> initiateConversation(String token, {
    required String postUUID,
    required String message,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/posts/${Uri.encodeComponent(postUUID)}/initiate",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token',
      },
      data: {
        "message": message,
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
      data: ChannelResponse.fromJson(response.response!.data["channel"]),
      response: response.response,
    );
  }

  Future<ApiResponse<ChannelResponse?>> getChannelFromPost(String token, {
    required String postUUID,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/posts/${Uri.encodeComponent(postUUID)}",
      method: "GET",
      headers: {
        'Authorization': 'Bearer $token',
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
      data: ChannelResponse.fromJson(response.response!.data["channel"]),
      response: response.response,
    );
  }

  Future<ApiResponse<List<ChannelResponse>>> getIncomingMessages(String token, {
    int offset = 0,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/incoming",
      method: "GET",
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    List<ChannelResponse> channels = [];

    for (var channel in response.response!.data["channels"]) {
      channels.add(ChannelResponse.fromJson(channel));
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: response.response!.statusCode! == 200,
      data: channels,
      response: response.response,
    );
  }

  Future<ApiResponse<List<ChannelResponse>>> getOutgoingMessages(String token, {
    int offset = 0,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/channels/outgoing",
      method: "GET",
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response == null ||
      response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    List<ChannelResponse> channels = [];

    for (var channel in response.response!.data["channels"]) {
      channels.add(ChannelResponse.fromJson(channel));
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: response.response!.statusCode! == 200,
      data: channels,
      response: response.response,
    );
  }
}