import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class SearchResultData {
  final String name;
  final String? address;
  final LatLng position;

  SearchResultData({
    required this.name,
    required this.position,
    this.address
  });

}

class OSMApi {
  static Future<Response?> search(String query) async {
    // Uses the OpenStreetMap Nominatim API
    var url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=20';

    return await Requests.fetchEndpoint(url);
  }

  static Future<Response?> getLocationName(LatLng position) async {
    // Uses the OpenStreetMap Nominatim API
    var url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';

    return await Requests.fetchEndpoint(url);
  }
}