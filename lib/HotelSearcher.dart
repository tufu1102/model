import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(HotelSearchApp());
}

class HotelSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HotelSearchScreen(),
    );
  }
}

class HotelSearchScreen extends StatefulWidget {
  @override
  _HotelSearchScreenState createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
    ));
    setState(() {
      _currentPosition = position;
    });
    _updateMapLocation();
  }

  void _updateMapLocation() {
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _searchHotels(String query) {
    // Mock implementation for hotel search
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('hotel1'),
          position: LatLng(_currentPosition!.latitude + 0.01, _currentPosition!.longitude + 0.01),
          infoWindow: InfoWindow(title: 'Hotel Paradise', snippet: '4.5 stars'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('hotel2'),
          position: LatLng(_currentPosition!.latitude - 0.01, _currentPosition!.longitude - 0.01),
          infoWindow: InfoWindow(title: 'Luxury Inn', snippet: '4.7 stars'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchHotels(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
