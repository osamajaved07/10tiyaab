// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   LatLng _initialPosition = const LatLng(24.8607, 67.0011); // Default location (Karachi, Pakistan)
//   late LatLng _currentPosition;
//   bool _isLocationEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionAndFetchLocation();
//   }

//   Future<void> _checkPermissionAndFetchLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _showEnableLocationPopup();
//       return;
//     }

//     PermissionStatus permission = await Permission.locationWhenInUse.request();
//     if (permission.isGranted) {
//       _getCurrentLocation();
//     } else if (permission.isPermanentlyDenied) {
//       openAppSettings();
//     } else {
//       _showPermissionDeniedMessage();
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _isLocationEnabled = true;
//       });
//       _moveCameraToCurrentLocation();
//     } catch (e) {
//       print('Error getting current location: $e');
//       // Fallback to default location if there's an error
//       setState(() {
//         _currentPosition = _initialPosition;
//         _isLocationEnabled = true;
//       });
//       _moveCameraToCurrentLocation();
//     }
//   }

//   void _moveCameraToCurrentLocation() {
//     mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(_currentPosition, 15.0),
//     );
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void _showEnableLocationPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enable Location Services'),
//           content: Text('Please enable location services to proceed.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 await Geolocator.openLocationSettings();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPermissionDeniedMessage() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Location Permission Denied'),
//           content: Text('Please grant location permission to proceed.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps with Location'),
//       ),
//       body: _isLocationEnabled
//           ? GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition,
//                 zoom: 15.0,
//               ),
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }