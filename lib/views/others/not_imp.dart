// class _FindSpState extends State<FindSp> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   CameraPosition _initialCameraPosition = const CameraPosition(
//     target: LatLng(24.8607, 67.0011), // Default location
//     zoom: 18,
//   );

//   late Position _currentPosition;
//   bool _isMapLoading = true; // Tracks map loading state
//   bool _isSearchingForProviders = true; // Tracks provider search state
//   final TextEditingController _locationController = TextEditingController();
//   final _secureStorage = const FlutterSecureStorage();
//   String _selectedServiceProvider = "Unknown Provider";

//   // For controlling the animated container visibility
//   bool _showFirst = false;
//   bool _showSecond = false;
//   bool _showThird = false;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _getStoredServiceProvider();

//     // Delay for showing each container one by one
//     Future.delayed(Duration(seconds: 12), () {
//       setState(() {
//         _isSearchingForProviders = false;
//         // Trigger the animations with delays
//         Timer(Duration(milliseconds: 200), () {
//           setState(() {
//             _showFirst = true;
//           });
//         });
//         Timer(Duration(milliseconds: 600), () {
//           setState(() {
//             _showSecond = true;
//           });
//         });
//         Timer(Duration(milliseconds: 1000), () {
//           setState(() {
//             _showThird = true;
//           });
//         });
//       });
//     });
//   }

//   Widget _buildServiceProviderContainers() {
//     return Column(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.15,
//         ),
//         _buildAnimatedServiceProviderContainer(
//             _showFirst, "Kamran Ghulam", _selectedServiceProvider, "Rs 400"),
//         _buildAnimatedServiceProviderContainer(
//             _showSecond, "Babar khan", _selectedServiceProvider, "Rs 600"),
//         _buildAnimatedServiceProviderContainer(
//             _showThird, "Rizwan Ali", _selectedServiceProvider, "Rs 800"),
//       ],
//     );
//   }

//   // The animated container that will slide in from the top
//   Widget _buildAnimatedServiceProviderContainer(
//       bool isVisible, String providerName, String skill, String price) {
//     return AnimatedSlide(
//       offset: isVisible ? Offset(0, 0) : Offset(0, -1), // Slide from top
//       duration: Duration(milliseconds: 500), // Duration of the slide animation
//       curve: Curves.easeInOut, // Easing curve
//       child: AnimatedOpacity(
//         opacity: isVisible ? 1.0 : 0.0, // Fade in the container
//         duration: Duration(milliseconds: 500), // Duration of the opacity change
//         child: _buildServiceProviderContainer(providerName, skill, price),
//       ),
//     );
//   }

//   // The static service provider container
//   Widget _buildServiceProviderContainer(
//       String providerName, String skill, String price) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(168, 4, 190, 190),
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 providerName,
//                 style: TextStyle(
//                     color: ttextColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: tsmallfontsize(context)),
//               ),
//               Text(
//                 "Fair: $price",
//                 style: TextStyle(
//                     color: ttextColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: tsmallfontsize(context)),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Text(
//             "Skill: $skill",
//             style: TextStyle(color: ttextColor),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("Accept"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("Decline"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
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
//                     myLocationEnabled:
//                         true, // Show the user's location on the map
//                     myLocationButtonEnabled:
//                         false, // Disable the built-in location button
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                   if (_isSearchingForProviders)
//                     Center(
//                       child: SpinKitRipple(
//                         size: screenHeight * 0.4,
//                         color: tPrimaryColor,
//                       ),
//                     ),
//                   if (!_isSearchingForProviders)
//                     _buildServiceProviderContainers(),
//                   showLocationField(screenHeight),
//                   getCurrentLocation(screenHeight, screenWidth),
//                   cancelButton(screenHeight, screenWidth, context),
//                 ],
//               );
//             }),
//     );
//   }
// }
