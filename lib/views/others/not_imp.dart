// // import 'package:permission_handler/permission_handler.dart';

// Future<void> _getCurrentLocation() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Show a dialog to ask the user to enable location services
//     _showLocationDialog(
//       context,
//       'Location services are disabled. Please enable them in settings.',
//       openLocationSettings: true,
//     );
//     return;
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied. Show a dialog to ask the user to enable permissions in settings
//       _showLocationDialog(
//         context,
//         'Location permissions are denied. Please allow permissions in settings.',
//         openAppSettings: true,
//       );
//       return;
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are permanently denied, handle accordingly by directing to settings
//     _showLocationDialog(
//       context,
//       'Location permissions are permanently denied. Please enable them in settings.',
//       openAppSettings: true,
//     );
//     return;
//   }

//   try {
//     _currentPosition = await Geolocator.getCurrentPosition();
//     setState(() {
//       _initialCameraPosition = CameraPosition(
//         target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//         zoom: 14.4746,
//       );
//     });

//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         _initialCameraPosition,
//       ),
//     );
//   } catch (e) {
//     print("Error getting location: $e");
//   }
// }


// import 'package:permission_handler/permission_handler.dart';

// void _showLocationDialog(BuildContext context, String message,
//     {bool openAppSettings = false, bool openLocationSettings = false}) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Location Access Required'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();
//               if (openAppSettings) {
//                 await openAppSettings(); // Open app settings
//               }
//               if (openLocationSettings) {
//                 await Geolocator.openLocationSettings(); // Open location settings
//               }
//             },
//             child: Text('Open Settings'),
//           ),
//         ],
//       );
//     },
//   );
// }
