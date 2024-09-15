// // // ignore_for_file: prefer_const_constructors, unnecessary_import, sort_child_properties_last, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, library_private_types_in_public_api, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:fyp_1/controllers/user_auth_controller.dart';
// import 'package:fyp_1/models/service_provider_list.dart';
// import 'package:fyp_1/utils/colors.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fyp_1/screens/location_selection_screen.dart'; // Import the location selection screen

// class UserHomeScreen extends StatefulWidget {
//   // final SharedPreferences prefs;

//   const UserHomeScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _UserHomeScreenState createState() => _UserHomeScreenState();
// }

// class _UserHomeScreenState extends State<UserHomeScreen> {
//   final AuthController authController = Get.find<AuthController>();
//   final TextEditingController _searchController = TextEditingController();
//   final ValueNotifier<List<dynamic>> _suggestionsNotifier = ValueNotifier([]);
//   final FocusNode _searchFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     _searchController.addListener(() {
//       final query = _searchController.text;
//       if (query.isNotEmpty) {
//         _fetchSuggestions(query);
//       } else {
//         _suggestionsNotifier.value = [];
//       }
//     });
//   }

//   Future<void> _fetchSuggestions(String query) async {
//     final suggestions = await authController.fetchSuggestions(query);
//     _suggestionsNotifier.value = suggestions ?? [];
//   }

//   void _onSuggestionSelected(String suggestion) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LocationSelectionScreen(serviceProvider: suggestion),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: tSecondaryColor,
//         appBar: AppBar(
//           backgroundColor: tSecondaryColor,
//           elevation: 0,

//           actions: [
//             IconButton(
//               onPressed: () {
//                 Get.toNamed("/chatscreen");
//                 print('Chat icon pressed');
//               },
//               icon: Icon(
//                 Icons.chat_outlined,
//                 color: tPrimaryColor,
//                 size: 30,
//               ),
//             ),
//             SizedBox(width: 16), // Add space between chat icon and edge
//           ],
//           title: Text(
//             '10tiyaab',
//             style: TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
//           ),
//         ),
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             final screenWidth = constraints.maxWidth;
//             final screenHeight = constraints.maxHeight;

//             return SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: screenHeight * 0.01,
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
//                     child: Row(
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             Container(
//                               width: 2,
//                               height: screenHeight * 0.08,
//                               color: Colors.grey,
//                             ),
//                             Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(width: screenWidth * 0.015),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: screenWidth,
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: screenHeight * 0.001,
//                                   horizontal: screenWidth * 0.04,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.search, color: Colors.grey),
//                                     SizedBox(width: screenWidth * 0.02),
//                                     Expanded(
//                                       child: TextField(
//                                         focusNode: _searchFocusNode,
//                                         controller: _searchController,
//                                         decoration: InputDecoration(
//                                           hintText: 'Search service provider',
//                                           hintStyle: TextStyle(
//                                             color: Color(0xFF616161),
//                                             fontSize: screenWidth * 0.045,
//                                           ),
//                                           border: InputBorder.none,
//                                         ),
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.045,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               ValueListenableBuilder<List<dynamic>>(
//                                 valueListenable: _suggestionsNotifier,
//                                 builder: (context, suggestions, child) {
//                                   return Container(
//                                     margin: EdgeInsets.only(
//                                         top: 8.0),
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 8.0),
//                                     width: screenWidth,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.3),
//                                           spreadRadius: 2,
//                                           blurRadius: 5,
//                                           offset: Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       children: suggestions.isNotEmpty
//                                           ? suggestions.map((suggestion) {
//                                               return ListTile(
//                                                 title: Text(suggestion[
//                                                     'name']),
//                                                 onTap: () => _onSuggestionSelected(suggestion['name']),
//                                               );
//                                             }).toList()
//                                           : [
//                                               ListTile(
//                                                   title: Text('No suggestions'))
//                                             ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                               SizedBox(height: screenHeight * 0.015),
//                               Container(
//                                 width: screenWidth,
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: screenHeight * 0.001,
//                                   horizontal: screenWidth * 0.04,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.search, color: Colors.grey),
//                                     SizedBox(width: screenWidth * 0.02),
//                                     Expanded(
//                                       child: TextField(
//                                         decoration: InputDecoration(
//                                           hintText: 'Where to?',
//                                           hintStyle: TextStyle(
//                                             color: Color(0xFF616161),
//                                             fontSize: screenWidth * 0.045,
//                                           ),
//                                           border: InputBorder.none,
//                                         ),
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.045,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: screenHeight * 0.04),
//                         Container(
//                           width: screenWidth,
//                           height: screenHeight * 0.2,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 121, 121, 121)
//                                     .withOpacity(
//                                         0.5),
//                                 spreadRadius: 5,
//                                 blurRadius: 7,
//                                 offset: Offset(
//                                     0, 3),
//                               ),
//                             ],
//                             gradient: LinearGradient(
//                               colors: [Color(0xFF04BEBE), Color(0xFF025858)],
//                               stops: [0.47, 1.0],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: screenHeight * 0.03,
//                                 horizontal: screenWidth * 0.04),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Skillful Person\nBook Now →',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: screenWidth * 0.05,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/images/worker.png',
//                                   width: screenWidth * 0.3,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.05),
//                         Text(
//                           'Suggestions',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: screenWidth * 0.05,
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.025),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                               width: screenWidth * 0.4,
//                               height: screenHeight * 0.1,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Plumber',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.045,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: screenWidth * 0.4,
//                               height: screenHeight * 0.1,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Electrician',
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.045,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         bottomNavigationBar: CurvedNavigationBar(
//           height: screenHeight * 0.075,
//           backgroundColor: Colors.transparent,
//           color: tPrimaryColor,
//           buttonBackgroundColor: Colors.white,
//           items: <Widget>[
//             Icon(Icons.home, size: 30, color: Colors.white),
//             Icon(Icons.person, size: 30, color: Colors.white),
//           ],
//           onTap: (index) {
//             // Handle bottom navigation
//           },
//         ),
//       ),
//     );
//   }
// }
