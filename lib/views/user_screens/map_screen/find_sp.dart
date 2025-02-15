// ignore_for_file: unnecessary_null_comparison, unused_field
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/dummy_service_providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class FindSp extends StatefulWidget {
  const FindSp({super.key});
  @override
  State<FindSp> createState() => _FindSpState();
}

class _FindSpState extends State<FindSp> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(24.8607, 67.0011), // Default location
    zoom: 18,
  );
  Position? _currentPosition; // Use nullable type
  bool _isMapLoading = true;
  bool _isSearchingForProviders = true;
  final TextEditingController _locationController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  String _selectedServiceProvider = "Unknown Provider";
  // For controlling the animated container visibility
  bool _showFirst = false;
  bool _showSecond = false;
  bool _showThird = false;
  // List of dummy service providers
  List<ServiceProvider> _serviceProviders = [];
  List<ServiceProvider> _filteredServiceProviders = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getStoredServiceProvider();
    _serviceProviders = dummyServiceProviders; // Assign dummy service providers
    final arguments = Get.arguments as Map?;
    if (arguments != null) {
      _selectedServiceProvider =
          arguments['serviceProvider'] ?? "Unknown Provider";
      print("Selected Service Provider: $_selectedServiceProvider");
    }
    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        _isSearchingForProviders = false;
        // Trigger the animations with delays
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _showFirst = true;
          });
        });
        Timer(const Duration(seconds: 5), () {
          setState(() {
            _showSecond = true;
          });
        });
        Timer(const Duration(seconds: 8), () {
          setState(() {
            _showThird = true;
          });
        });
      });
    });
  }

  void _getStoredServiceProvider() async {
    // Retrieve the stored service provider from secure storage
    String? storedProvider = await _secureStorage.read(key: 'selectedProvider');
    if (storedProvider != null) {
      setState(() {
        _selectedServiceProvider = storedProvider;
      });
      print('Selected Service Provider: $storedProvider');
    } else {
      print('No service provider found in local storage.');
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: tlightPrimaryColor,
          elevation: 8,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Confirm"),
          content: Text(
              "Are you sure you want to stop finding $_selectedServiceProvider?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: ttextColor)),
            ),
            TextButton(
              onPressed: () async {
                Get.offNamed('/homescreen');
              },
              child: Text("Yes", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
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
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = placemarks[0]; // Get the first result
      // Construct a user-friendly address
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      setState(() {
        _locationController.text = address;
        _initialCameraPosition = CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
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
      // Filter service providers based on the new location
      _filterServiceProviders();
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
        });
        // Filter service providers based on the new location
        _filterServiceProviders();
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
              onPressed: () => Get.back(),
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

  void _showServiceProviderDialog(BuildContext context, String travelTime,
      String providerName, String price, String skill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(29, 229, 229, 229),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/default.png'),
                        radius: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(providerName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: tmidfontsize(context))),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          Text(
                            skill,
                            style: TextStyle(fontSize: tsmallfontsize(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Travel time: $travelTime"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text("Price: $price"),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor),
                    onPressed: () {
                      // Navigator.pop(context); // Close the dialog
                    },
                    child: Text("Accept"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _filterServiceProviders() {
    if (_currentPosition != null) {
      _filteredServiceProviders = _serviceProviders.where((provider) {
        double distanceInMeters = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          provider.location.latitude,
          provider.location.longitude,
        );
        // Assume a radius of 5km for demonstration purposes
        bool isInRadius = distanceInMeters <= 5000;
        bool isMatchingSkill = _selectedServiceProvider.isEmpty ||
            provider.skill == _selectedServiceProvider;
        bool isIncluded = isInRadius && isMatchingSkill;
        print(
            "Provider: ${provider.name}, Distance: ${distanceInMeters.toStringAsFixed(2)}m, In Radius: $isInRadius, Matching Skill: $isMatchingSkill, Included: $isIncluded");
        return isIncluded;
      }).toList();

      // Update UI
      setState(() {});
    }
  }

  Widget _buildServiceProviderContainers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _filteredServiceProviders.map((provider) {
        return _buildAnimatedServiceProviderContainer(
          true, // Always visible for simplicity
          provider.travelTime,
          provider.name,
          provider.skill,
          provider.price,
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedServiceProviderContainer(bool isVisible,
      String travelTime, String providerName, String skill, String price) {
    return AnimatedSlide(
      offset: isVisible ? Offset(0, 0) : Offset(0, -1), // Slide from top
      duration: Duration(milliseconds: 1000), // Duration of the slide animation
      curve: Curves.easeInOut, // Easing curve
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0, // Fade in the container
        duration: Duration(milliseconds: 500), // Duration of the opacity change
        child: _buildServiceProviderContainer(
            travelTime, providerName, skill, price),
      ),
    );
  }

  Widget _buildServiceProviderContainer(
      String travelTime, String providerName, String skill, String price) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(168, 4, 190, 190),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                providerName,
                style: TextStyle(
                    color: ttextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: tsmallfontsize(context)),
              ),
              Text(
                "Fare: $price",
                style: TextStyle(
                    color: ttextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: tsmallfontsize(context)),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Skill: $skill",
            style: TextStyle(color: ttextColor),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showServiceProviderDialog(
                      context, travelTime, providerName, price, skill);
                },
                child: Text("View"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  backgroundColor: Colors.green,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/chatscreen');
                },
                child: Row(
                  children: [
                    Text("Chat"),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.chat_outlined)
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
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
            ))
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
                  if (_isSearchingForProviders)
                    Center(
                      child: SpinKitRipple(
                        size: screenHeight * 0.4,
                        color: tPrimaryColor,
                      ),
                    ),
                  if (!_isSearchingForProviders)
                    Center(child: _buildServiceProviderContainers()),
                  showLocationField(screenHeight, screenWidth),
                  getCurrentLocation(screenHeight, screenWidth),
                  cancelButton(screenHeight, screenWidth, context),
                ],
              );
            }),
    );
  }

  Positioned cancelButton(
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
                Colors.grey,
                const Color.fromARGB(255, 197, 197, 197),
              ], // Your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context);
              // Get.offNamed('/homescreen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.016,
                  horizontal: screenWidth * 0.19),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancel',
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

  Positioned showLocationField(double screenHeight, double screenWidth) {
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
          style: TextStyle(color: ttextColor, fontWeight: FontWeight.w500),
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
    );
  }
}
