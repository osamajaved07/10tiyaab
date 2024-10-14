// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fyp_1/controllers/sp_auth_controller.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controllers/user_auth_controller.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final UserAuthController _authController = Get.find<UserAuthController>();
//   final SpAuthController _spauthController = Get.find<SpAuthController>();
//   final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _startSplashScreenTimer();
//     _performBackgroundTasks();
//   }

//   void _startSplashScreenTimer() async {
//     await Future.delayed(Duration(seconds: 16));
//     setState(() {
//       _isLoading = true;
//     });
//   }

//   Future<void> _performBackgroundTasks() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final bool isOnboardingCompleted =
//           prefs.getBool('isOnboardingCompleted') ?? false;
//       final String? userType = await _secureStorage.read(key: 'user_type');

//       final results = await Future.wait([
//         _authController.isLoggedIn(),
//         _spauthController.isspLoggedIn(),
//       ]);
//       final bool isLoggedin = results[0];
//       final bool isspLoggedin = results[1];

//       if (isOnboardingCompleted) {
//         if (isLoggedin) {
//           print('Type: $userType');
//           Get.offAllNamed("/homescreen");
//         } else if (isspLoggedin) {
//           print('Type: $userType');
//           Get.offAllNamed("/sphome");
//         } else {
//           Get.offAllNamed("/selection");
//         }
//       } else {
//         Get.offAllNamed('/onboarding_screen');
//       }
//     } catch (e) {
//       print("Failed to retrieve profile after token refresh: $e");
//       Get.offAllNamed('/userLogin');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF04BEBE),
//       body: Stack(
//         children: [
//           Center(
//             child: Image.asset(
//               'assets/images/logo1.png',
//               width: MediaQuery.of(context).size.width * 0.6,
//               height: MediaQuery.of(context).size.height * 0.3,
//             ),
//           ),
//           if (_isLoading)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 12),
//                   Text('Loading...', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _SpMapScreenState extends State<SpMapScreen> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   CameraPosition _initialCameraPosition = const CameraPosition(
//     target: LatLng(24.8607, 67.0011), // Default location
//     zoom: 18,
//   );

//   late Position _currentPosition;
//   bool _isMapLoading = true;
//   final TextEditingController _locationController = TextEditingController();

//   // Button states
//   String _connectionState = "Offline"; // Initial state is offline

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // Function to get the current location of the user
//   Future<void> _getCurrentLocation() async {
//     // ... (same as your current _getCurrentLocation method)
//   }

//   // Function to handle connection state changes
//   void _toggleConnection() {
//     if (_connectionState == "Offline") {
//       setState(() {
//         _connectionState = "Connecting";
//       });

//       // Simulate the connecting delay
//       Future.delayed(Duration(seconds: 2), () {
//         setState(() {
//           _connectionState = "Online"; // Switch to online after delay
//         });
//       });
//     } else if (_connectionState == "Online") {
//       setState(() {
//         _connectionState = "Connecting";
//       });

//       // Simulate the connecting delay
//       Future.delayed(Duration(seconds: 2), () {
//         setState(() {
//           _connectionState = "Offline"; // Switch to offline after delay
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isMapLoading
//           ? Center(
//               child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   color: tPrimaryColor,
//                   backgroundColor: Colors.blueGrey,
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text("Loading...")
//               ],
//             ))
//           : LayoutBuilder(builder: (context, constraints) {
//               final screenWidth = constraints.maxWidth;
//               final screenHeight = constraints.maxHeight;
//               return Stack(
//                 children: [
//                   GoogleMap(
//                     mapType: MapType.normal,
//                     initialCameraPosition: _initialCameraPosition,
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: false,
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                   locationDisplayDialog(screenHeight),
//                   getCurrentLocation(screenHeight, screenWidth),
//                   connectionToggleButton(screenHeight, screenWidth), // Connection button
//                 ],
//               );
//             }),
//     );
//   }

//   Positioned connectionToggleButton(double screenHeight, double screenWidth) {
//     return Positioned(
//       top: screenHeight * 0.06,
//       right: 20,
//       child: ElevatedButton(
//         onPressed: _toggleConnection, // Toggle connection when pressed
//         style: ElevatedButton.styleFrom(
//           primary: _connectionState == "Online"
//               ? Colors.teal
//               : _connectionState == "Connecting"
//                   ? Colors.orange
//                   : Colors.grey, // Color based on connection state
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               _connectionState,
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(width: 5),
//             Icon(
//               Icons.check_circle,
//               color: Colors.white,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Positioned getCurrentLocation(double screenHeight, double screenWidth) {
//     return Positioned(
//       bottom: screenHeight * 0.13,
//       right: screenWidth * 0.02,
//       child: FloatingActionButton(
//         onPressed: _getCurrentLocation,
//         child: Icon(Icons.my_location),
//         backgroundColor: tPrimaryColor,
//       ),
//     );
//   }

//   Positioned locationDisplayDialog(double screenHeight) {
//     return Positioned(
//       top: screenHeight * 0.06,
//       left: 5,
//       right: 20,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//               onPressed: () {
//                 Get.back();
//               },
//               icon: Icon(Icons.arrow_back)),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color.fromARGB(255, 121, 121, 121)
//                         .withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _locationController,
//                 style:
//                     TextStyle(color: ttextColor, fontWeight: FontWeight.w500),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintText: 'Search location',
//                 ),
//                 onSubmitted: (value) {
//                   _searchLocation(value);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
