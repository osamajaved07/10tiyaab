// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fyp_1/utils/colors.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class FindSp extends StatefulWidget {
//   const FindSp({super.key});

//   @override
//   State<FindSp> createState() => _FindSpState();
// }

// class _FindSpState extends State<FindSp> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

//   CameraPosition _initialCameraPosition = const CameraPosition(
//     target: LatLng(24.8607, 67.0011),
//     zoom: 18,
//   );

//   late Position _currentPosition;
//   bool _isMapLoading = true;
//   bool _isSearchingForProviders = true;
//   final TextEditingController _locationController = TextEditingController();
//   String? _selectedServiceProvider;
//   bool _showNotification = false;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     final arguments = Get.arguments as Map<String, dynamic>?;
//     if (arguments != null) {
//       _selectedServiceProvider = arguments['serviceProvider'] ?? "Unknown Provider";
//     }
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         _isSearchingForProviders = false;
//         _showNotification = true;
//       });
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _showLocationDialog(
//         context,
//         'Location services are disabled. Please enable them in settings.',
//         openLocationSettings: true,
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showLocationDialog(
//           context,
//           'Location permissions are denied. Please allow permissions in settings.',
//           openAppSettings: true,
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _showLocationDialog(
//         context,
//         'Location permissions are permanently denied. Please enable them in settings.',
//         openAppSettings: true,
//       );
//       return;
//     }

//     try {
//       _currentPosition = await Geolocator.getCurrentPosition();
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentPosition.latitude, _currentPosition.longitude);

//       Placemark place = placemarks[0];

//       String address = "${place.street}, ${place.subLocality}, ${place.locality}";
//       setState(() {
//         _locationController.text = address;
//         _initialCameraPosition = CameraPosition(
//           target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//           zoom: 18,
//         );
//         _isMapLoading = false;
//       });

//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   void _showLocationDialog(BuildContext context, String message, {bool openAppSettings = false, bool openLocationSettings = false}) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Location Access Required'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (openAppSettings) {
//                   await openAppSettings;
//                 }
//                 if (openLocationSettings) {
//                   await Geolocator.openLocationSettings();
//                 }
//               },
//               child: Text('Open Settings'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildServiceProviderContainers() {
//     return Column(
//       children: [
//         _buildServiceProviderContainer("Provider 1", "2.5 km away"),
//         _buildServiceProviderContainer("Provider 2", "3.0 km away"),
//         _buildServiceProviderContainer("Provider 3", "4.0 km away"),
//       ],
//     );
//   }

//   Widget _buildServiceProviderContainer(String providerName, String distance) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: tPrimaryColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             providerName,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(
//             distance,
//             style: TextStyle(color: Colors.white),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("Accept"),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.green,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("Decline"),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isMapLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: tPrimaryColor,
//                   ),
//                   SizedBox(height: 8),
//                   Text("Loading..."),
//                 ],
//               ),
//             )
//           : Stack(
//               children: [
//                 GoogleMap(
//                   mapType: MapType.normal,
//                   initialCameraPosition: _initialCameraPosition,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: false,
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                 ),
//                 if (_isSearchingForProviders)
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: tPrimaryColor,
//                     ),
//                   ),
//                 if (!_isSearchingForProviders) _buildServiceProviderContainers(),
//               ],
//             ),
//     );
//   }
// }
