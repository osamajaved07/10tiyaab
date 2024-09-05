// @override
// Widget build(BuildContext context) {
//   final defaultPinTheme = PinTheme(
//     width: 56,
//     height: 56,
//     textStyle: TextStyle(
//         fontSize: 24, // Increased size
//         color: Color.fromRGBO(30, 60, 87, 1),
//         fontWeight: FontWeight.w600),
//     decoration: BoxDecoration(
//       border: Border.all(color: Color.fromRGBO(120, 120, 121, 1)),
//       borderRadius: BorderRadius.circular(20),
//     ),
//   );

//   final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//     border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
//     borderRadius: BorderRadius.circular(8),
//   );

//   final submittedPinTheme = defaultPinTheme.copyWith(
//     decoration: defaultPinTheme.decoration?.copyWith(
//       color: Color.fromRGBO(245, 255, 255, 1),
//     ),
//   );

//   return Scaffold(
//     backgroundColor: tSecondaryColor,
//     extendBodyBehindAppBar: true,
//     body: LayoutBuilder(builder: ((context, constraints) {
//       final screenWidth = constraints.maxWidth;
//       final screenHeight = constraints.maxHeight;
//       return SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: screenWidth / 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: screenHeight / 10),
//               // Place the back button and edit email button here
//               Align(
//                 alignment: Alignment.topLeft, // Align to the top left
//                 child: Padding(
//                   padding: EdgeInsets.only(top: screenHeight * 0.05),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(Icons.arrow_back),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.offNamed("/phoneverify");
//                         },
//                         child: Text(
//                           "Edit Email?",
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenHeight / 10), // Adjust spacing after the row
//               Image.asset(
//                 "assets/images/logo1.png",
//                 width: screenWidth * 0.4,
//                 height: screenHeight * 0.2,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Email Verification",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Enter 6 digits verification code we have sent to your email",
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Pinput(
//                 length: 6,
//                 defaultPinTheme: defaultPinTheme,
//                 focusedPinTheme: focusedPinTheme,
//                 submittedPinTheme: submittedPinTheme,
//                 showCursor: true,
//                 onCompleted: (pin) {
//                   _authController.verifyOtp(pin);
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: tPrimaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () async {
//                     await _authController.verifyOtp("pin");
//                   },
//                   child: Text(
//                     "Verify Email",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: ttextColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: screenHeight * 0.02,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween, 
//                 children: [
//                   Flexible(
//                     child: Row(
//                       children: [
//                         IconButton(
//                             onPressed: () {}, icon: Icon(Icons.arrow_back)),
//                         TextButton(
//                           onPressed: () {
//                             Get.offNamed("/phoneverify");
//                           },
//                           child: Text(
//                             "Edit Email?",
//                             style:
//                                 TextStyle(fontSize: 16, color: Colors.black),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       _resendButton(context),
//                       SizedBox(height: 16),
//                       Text(
//                         _start > 0 ? "Resend in $_start" : "",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ],
//                   ), 
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
//     })),
//   );
// }
