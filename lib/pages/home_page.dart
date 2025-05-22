import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import '../services/places_service.dart';
import '../themes/theme_provider.dart';
import '../widgets/spot_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlacesService _placesService = PlacesService();
  Position? _currentPosition;
  bool _loading = false;
  List<SearchResult> _places = [];

  Future<void> _getLocationAndPlaces() async {
    setState(() => _loading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });

      final places = await _placesService.getNearbyPlaces(position);

      setState(() {
        _places = places;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print("Error getting location or places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Spot Finder"),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _getLocationAndPlaces,
              icon: const Icon(Icons.location_on),
              label: const Text("Temukan Tempat Terdekat"),
            ),
            const SizedBox(height: 10),
            if (_loading) const CircularProgressIndicator(),
            if (_currentPosition != null && _places.isNotEmpty)
              Text(
                "Lokasi: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: _places.isEmpty
                  ? const Text("Tidak ada tempat ditemukan.")
                  : ListView.builder(
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  final spot = _places[index];
                  return SpotCard(
                    title: spot.name ?? "Tanpa Nama",
                    subtitle: spot.vicinity ?? "Alamat tidak tersedia",
                    distance: "-", // Belum tersedia dari API ini
                    onTap: () async {
                      if (spot.placeId != null) {
                        final detail = await _placesService.getPlaceDetails(spot.placeId!);
                        if (detail != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(place: detail),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
