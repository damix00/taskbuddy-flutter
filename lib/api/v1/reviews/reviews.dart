import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

class Reviews {
  Future<bool> deleteReview(
    String token,
    String uuid
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/reviews/${Uri.encodeComponent(uuid)}",
      method: "DELETE",
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (
      response == null
      || response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return false;
    }
    
    return true;
  }

  Future<bool> updateReview(
    String token,
    {
      required String uuid,
      required String title,
      required String description,
      required double rating,
    }
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/reviews/${Uri.encodeComponent(uuid)}",
      method: "PUT",
      headers: {
        'Authorization': 'Bearer $token',
      },
      data: {
        'title': title,
        'description': description,
        'rating': rating,
      }
    );

    if (
      response == null
      || response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return false;
    }
    
    return true;
  }

  Future<bool> reportReview(
    String token,
    String uuid,
    String report
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/reviews/${Uri.encodeComponent(uuid)}/report",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token',
      },
      data: {
        'reason': report
      }
    );

    if (
      response == null
      || response.timedOut ||
      response.response?.statusCode != 200
    ) {
      return false;
    }
    
    return true;
  }
}