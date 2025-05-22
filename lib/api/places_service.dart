import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

class PlacesService {
  final GooglePlace _googlePlace = GooglePlace("AIzaSyBvDUgxwmk1z4DtwUl4kFLeB6r2ldHnHCA");

  Future<List<Map<String, dynamic>>> getNearbyPlaces(Position position) async {
    final result = await _googlePlace.search.getNearBySearch(
      Location(lat: position.latitude, lng: position.longitude),
      1500,
    );

    if (result != null && result.results != null) {
      return result.results!.map((place) {
        final lat = place.geometry?.location?.lat;
        final lng = place.geometry?.location?.lng;
        double distance = 0.0;
        if (lat != null && lng != null) {
          distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            lat,
            lng,
          );
        }
        return {
          'name': place.name ?? 'Tanpa Nama',
          'address': place.vicinity ?? '',
          'distance': '${(distance / 1000).toStringAsFixed(2)} km',
        };
      }).toList();
    }
    return [];
  }
}
