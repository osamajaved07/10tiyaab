// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SpMapScreen extends StatefulWidget {
  const SpMapScreen({super.key});

  @override
  State<SpMapScreen> createState() => _SpMapScreenState();
}

class _SpMapScreenState extends State<SpMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(24.8607, 67.0011), // Default location
    zoom: 18,
  );

  late Position _currentPosition;
  bool _isMapLoading = true; // Tracks map loading state
  final TextEditingController _locationController = TextEditingController();
  String _connectionState = "Offline";
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show a dialog to ask the user to enable location services
      _showLocationDialog(
        context,
        'Location services are disabled. Please enable them in settings.',
        openLocationSettings: true,
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied. Show a dialog to ask the user to enable permissions in settings
        _showLocationDialog(
          context,
          'Location permissions are denied. Please allow permissions in settings.',
          openAppSettings: true,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle accordingly by directing to settings
      _showLocationDialog(
        context,
        'Location permissions are permanently denied. Please enable them in settings.',
        openAppSettings: true,
      );
      return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      // Use reverse geocoding to get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0]; // Get the first result
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      setState(() {
        _locationController.text = address;
        _initialCameraPosition = CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 18,
        );
        _isMapLoading = false;
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          _initialCameraPosition,
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _toggleConnection() async {
    if (_connectionState == "Offline") {
      setState(() {
        _connectionState = "Connecting";
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _connectionState = "Online";
          print("Connection State: Online");
        });
        _storage.write(key: 'connectionState', value: 'Online'); // Store Online
      });
    } else if (_connectionState == "Online") {
      setState(() {
        _connectionState = "Connecting";
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _connectionState = "Offline";
          print("Connection State: Offline"); // Switch to offline after delay
        });
        _storage.write(key: 'connectionState', value: 'Offline');
      });
    }
  }

  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(
          location); // Use geocoding to convert address to lat/lng
      if (locations.isNotEmpty) {
        Location newLocation = locations.first;
        LatLng newLatLng = LatLng(newLocation.latitude, newLocation.longitude);

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newLatLng, zoom: 18),
          ),
        );

        // Update the current position and the text field
        setState(() {
          _currentPosition = Position(
            latitude: newLatLng.latitude,
            longitude: newLatLng.longitude,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: 1.0, // Add altitudeAccuracy
            headingAccuracy: 1.0,
          );
          // _locationController.text =
          //     "${newLatLng.latitude}, ${newLatLng.longitude}";
        });
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  void _showLocationDialog(BuildContext context, String message,
      {bool openAppSettings = false, bool openLocationSettings = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Access Required'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (openAppSettings) {
                  await openAppSettings; // Open app settings
                }
                if (openLocationSettings) {
                  await Geolocator
                      .openLocationSettings(); // Open location settings
                }
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMapLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: tPrimaryColor,
                  backgroundColor: Colors.blueGrey,
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Loading...")
              ],
            )) // Show loading spinner while map is loading
          : LayoutBuilder(builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _initialCameraPosition,
                    myLocationEnabled:
                        true, // Show the user's location on the map
                    myLocationButtonEnabled:
                        false, // Disable the built-in location button
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  locationDisplayDialog(screenHeight, screenWidth),
                  getCurrentLocation(screenHeight, screenWidth),
                  connectionToggleButton(screenHeight, screenWidth),
                  cancelButton(screenHeight, screenWidth),
                ],
              );
            }),
    );
  }

  Positioned cancelButton(double screenHeight, double screenWidth) {
    return Positioned(
      bottom: screenHeight * 0.05,
      left: screenWidth * 0.25,
      child: SizedBox(
        width: screenWidth * 0.5,
        child: ElevatedButton(
          onPressed: () {
            Get.offAllNamed('/sphome'); // Navigate to the home screen
          },
          style: ElevatedButton.styleFrom(
            elevation: 8,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Positioned connectionToggleButton(double screenHeight, double screenWidth) {
    return Positioned(
      top: screenHeight * 0.15,
      right: 20,
      child: ElevatedButton(
        onPressed: _toggleConnection,
        style: ElevatedButton.styleFrom(
          backgroundColor: _connectionState == "Online"
              ? tPrimaryColor
              : _connectionState == "Connecting"
                  ? Colors.orange
                  : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _connectionState,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: tsmallfontsize(context)),
            ),
            SizedBox(width: screenWidth * 0.02),
            Icon(
              _connectionState == "Online"
                  ? Icons.check_circle
                  : _connectionState == "Connecting"
                      ? Icons.more_horiz // Horizontal three-dot icon
                      : Icons.error_outline, // Warning icon for Offline
              color: Colors.white,
              size: screenWidth * 0.055,
            ),
          ],
        ),
      ),
    );
  }

  Positioned getCurrentLocation(double screenHeight, double screenWidth) {
    return Positioned(
      bottom: screenHeight * 0.13,
      right: screenWidth * 0.02,
      child: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
        backgroundColor: tPrimaryColor,
      ),
    );
  }

  Positioned locationDisplayDialog(double screenHeight, double screenWidth) {
    return Positioned(
      top: screenHeight * 0.06,
      left: screenWidth * 0.06, // 10% from the left
      right: screenWidth * 0.06,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 121, 121, 121)
                  .withOpacity(0.5), // Shadow color with opacity
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(0, 3), // Offset for the shadow (x, y)
            ),
          ],
        ),
        child: TextField(
          controller: _locationController,
          style: TextStyle(color: ttextColor, 
          fontWeight: FontWeight.w500,
          fontSize: tsmallfontsize(context)),
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Search location',
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {
            //     _searchLocation(_locationController
            //         .text); // Search location on pressing the search icon
            //   },
            // ),
          ),
          onSubmitted: (value) {
            _searchLocation(value);
          },
        ),
      ),
    );
  }
}
