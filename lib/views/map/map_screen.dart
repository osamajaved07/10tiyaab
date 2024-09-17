// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(24.8607, 67.0011), // Default location
    zoom: 14.4746,
  );

  late Position _currentPosition;

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
      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 14.4746,
        );
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
    // _currentPosition = await Geolocator.getCurrentPosition();

    // setState(() {
    //   _initialCameraPosition = CameraPosition(
    //     target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //     zoom: 14.4746,
    //   );
    // });

    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     _initialCameraPosition,
    //   ),
    // );
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

  // Move the camera to the user's current location
  Future<void> _goToUserLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      if (controller != null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 14.4746,
            ),
          ),
        );
      }
    } catch (e) {
      if (e is PlatformException) {
        print("Error moving camera: ${e.message}");
      } else {
        print("Unknown error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true, // Show the user's location on the map
              myLocationButtonEnabled:
                  false, // Disable the built-in location button
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              bottom: screenHeight * 0.13,
              right: screenWidth * 0.02,
              child: FloatingActionButton(
                onPressed: _goToUserLocation,
                child: Icon(Icons.my_location),
                backgroundColor: tPrimaryColor,
              ),
            ),
          ],
        );
      }),
    );
  }
}
