// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/custom_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class UserMapScreen extends StatefulWidget {
  const UserMapScreen({super.key});

  @override
  State<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(24.8607, 67.0011), // Default location
    zoom: 18,
  );
  late Position _currentPosition;
  bool _isMapLoading = true; // Tracks map loading state
  final TextEditingController _locationController = TextEditingController();
  final UserAuthController _authController = Get.find<UserAuthController>();
  String? _selectedServiceProvider; // To store the passed service provider

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // final arguments = Get.arguments as Map<String, dynamic>?;
    // if (arguments != null) {
    //   _selectedServiceProvider =
    //       arguments['serviceProvider'] ?? "Unknown Provider";
    //   print("Selected Service Provider: $_selectedServiceProvider");
    // }
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

      // Construct a user-friendly address
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

  Future<void> _saveLocation() async {
    if (_currentPosition != null) {
      await _authController.sendUserLocation(
          _currentPosition.latitude, _currentPosition.longitude);
      print(
          "Saved location for Service Provider: $_selectedServiceProvider"); // Log the selected service provider
    } else {
      errorSnackbar("Error", "Failed to get current location.");
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
              onPressed: () => Get.back,
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.toNamed("/homescreen");
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
                  showLocationField(screenHeight),
                  getCurrentLocation(screenHeight, screenWidth),
                  button(screenHeight, screenWidth, context),
                ],
              );
            }),
    );
  }

  Positioned button(
      double screenHeight, double screenWidth, BuildContext context) {
    return Positioned(
      bottom: screenHeight * 0.04,
      left: screenWidth * 0.19,
      right: screenWidth * 0.19,
      child: Material(
        elevation: 12,
        shadowColor: Colors.grey.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 52, 235, 235)
              ], // Your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: _saveLocation, // Call the save location function
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Confirm location',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: tsecondarytextColor,
                  fontSize: tmidfontsize(context)),
            ),
          ),
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

  Positioned showLocationField(double screenHeight) {
    return Positioned(
      top: screenHeight * 0.06,
      left: 5,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Get.toNamed("/homescreen");
              },
              icon: Icon(Icons.arrow_back)),
          Expanded(
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
                style:
                    TextStyle(color: ttextColor, fontWeight: FontWeight.w500),
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search location',
                ),
                onSubmitted: (value) {
                  _searchLocation(
                      value); // Search location when the user submits the location
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
