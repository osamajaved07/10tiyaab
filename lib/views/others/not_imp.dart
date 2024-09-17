// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';

// import '../../utils/colors.dart';

// class SpHomeScreen extends StatefulWidget {
//   const SpHomeScreen({super.key});

//   @override
//   State<SpHomeScreen> createState() => _SpHomeScreenState();
// }

// class _SpHomeScreenState extends State<SpHomeScreen> {
//   final FlutterSecureStorage storage = FlutterSecureStorage();

//   Future<String> _getUsername() async {
//     final username = await storage.read(key: 'username');
//     return username ?? 'User'; // Default to 'User' if username is not found
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: LayoutBuilder(builder: (context, constraints) {
//         final screenWidth = constraints.maxWidth;
//         final screenHeight = constraints.maxHeight;
//         return SingleChildScrollView(
//           child: Container(
//             height: screenHeight,
//             child: Stack(
//               children: [
//                 Container(
//                   width: screenWidth,
//                   height: screenHeight / 2.5,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         tPrimaryColor,
//                         tPrimaryColor.withOpacity(0.4),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: screenHeight / 6),
//                   height: screenHeight / 1,
//                   width: screenWidth,
//                   decoration: BoxDecoration(
//                     color: tlightPrimaryColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: screenHeight / 30,
//                         ),
//                         FutureBuilder<String>(
//                           future: _getUsername(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             } else if (snapshot.hasError) {
//                               return Text('Error loading username');
//                             } else {
//                               final username = snapshot.data ?? 'User';
//                               return Text(
//                                 "Hello $username",
//                                 style: TextStyle(
//                                   fontSize: screenHeight * 0.028,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: screenHeight / 10,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: screenWidth / 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Dashboard",
//                           style: TextStyle(
//                             fontSize: screenHeight * 0.035,
//                             color: ttextColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 print("Chat button pressed");
//                               },
//                               icon: Icon(Icons.chat_outlined),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 print("Notification button pressed");
//                               },
//                               icon: Icon(Icons.notifications_none_outlined),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
