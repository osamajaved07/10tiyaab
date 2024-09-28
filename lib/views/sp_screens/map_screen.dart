// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

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
    zoom: 14.4746,
  );

  late Position _currentPosition;
  bool _isMapLoading = true; // Tracks map loading state
  final TextEditingController _locationController = TextEditingController();

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

      // Construct a user-friendly address
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}";

      // Set the address in the TextField
      _locationController.text = address;
      // _locationController.text =
      //     "${_currentPosition.latitude}, ${_currentPosition.longitude}"; // Set current location in the text field
      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 14.4746,
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
            CameraPosition(target: newLatLng, zoom: 14.4746),
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
          _locationController.text =
              "${newLatLng.latitude}, ${newLatLng.longitude}";
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
                CircularProgressIndicator(),
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
                  Positioned(
                    top: screenHeight * 0.08,
                    left: 5,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121)
                                          .withOpacity(
                                              0.5), // Shadow color with opacity
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset: Offset(
                                      0, 3), // Offset for the shadow (x, y)
                                ),
                              ],
                            ),
                            child: GooglePlaceAutoCompleteTextField(
                              textEditingController: _locationController,
                              googleAPIKey:
                                  "AIzaSyCVhZrMtGQjtunjzG49_hZ_XmtxmXbzUMw",
                              // controller: _locationController,
                              inputDecoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Search location',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    _searchLocation(_locationController
                                        .text); // Search location on pressing the search icon
                                  },
                                ),
                              ),
                              debounceTime: 800,
                              countries: ["PK"], // Set to the desired country
                              isLatLngRequired: true,
                              getPlaceDetailWithLatLng:
                                  (Prediction prediction) {
                                print(
                                    "Selected place: ${prediction.description}");
                              },
                              // onSubmitted: (value) {
                              //   _searchLocation(
                              //       value); // Search location when the user submits the location
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.13,
                    right: screenWidth * 0.02,
                    child: FloatingActionButton(
                      onPressed: _getCurrentLocation,
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
