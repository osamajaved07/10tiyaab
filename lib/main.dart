// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, equal_keys_in_map, unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/auth_controller.dart';
import 'package:fyp_1/views/verifications/email_verify.dart';
import 'package:fyp_1/views/verifications/verify_final.dart';
import 'package:fyp_1/views/others/home.dart';
import 'package:fyp_1/views/professional_screens/professional_login.dart';
import 'package:fyp_1/views/professional_screens/professional_registration.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:fyp_1/views/others/splash_screen.dart';
import 'package:fyp_1/views/user_screens/contactus_screen.dart';
import 'package:fyp_1/views/user_screens/edit_profile_screen.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';
import 'package:fyp_1/views/user_screens/user_login.dart';
import 'package:fyp_1/views/user_screens/user_registration.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthController authController = Get.put(AuthController());
  final bool isLoggedIn = await authController.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  // final SharedPreferences prefs;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '10tiyaab',
      theme: ThemeData(
        primaryColor: Colors.black,
        useMaterial3: false,
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/selection', page: () => UserSelection()),
        GetPage(
            name: '/professionalregister',
            page: () => MazdoorRegistration(
                 )),
        GetPage(
            name: '/professionalLogin',
            page: () => MazdoorLogin(
                )),
        GetPage(
            name: '/userregister',
            page: () => UserRegister(
                )),
        GetPage(
            name: '/userLogin',
            page: () => UserLogin(
                )),
        GetPage(
            name: '/phoneverify',
            page: () => PhoneVerification(
                )),
        GetPage(name: '/verify', page: () => MyVerify()),
        GetPage(
            name: '/homescreen',
            page: () => UserHomeScreen(
                ),
            transition: Transition.fadeIn),
        GetPage(
            name: '/editprofile',
            page: () => EditProfilePage(),
            transition: Transition.fadeIn),

            GetPage(
            name: '/contactus',
            page: () => ContactUsScreen(),
            transition: Transition.fadeIn),
      ],
    );
  }
}

// class MazdoorIdStateChecker extends StatefulWidget {
//   @override
//   _MazdoorIdStateCheckerState createState() => _MazdoorIdStateCheckerState();
// }

// class _MazdoorIdStateCheckerState extends State<MazdoorIdStateChecker> {
//   bool isLoading = true; // Loading indicator while checking user state

//   @override
//   void initState() {
//     super.initState();
//     checkUserState(); // Check user state when the widget initializes
//   }

//   Future<void> checkUserState() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       // Check if user data exists
//       bool userDataExists =
//           prefs.containsKey('name') && prefs.containsKey('password');
//       if (userDataExists) {
//         // Navigate to home screen if user data exists
//         Get.offNamed("/homescreen");
//       } else {
//         // Navigate to login screen if user data doesn't exist
//         Get.offNamed("/professionalLogin");
//       }
//     } catch (e) {
//       // Handle any errors that occur during the check
//       print("Error checking user state: $e");
//       // Optionally, navigate to an error screen or show an error message
//     } finally {
//       setState(() {
//         isLoading = false; // Update loading state
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show loading indicator while checking user state
//     return Scaffold(
//       body: Center(
//         child: isLoading ? CircularProgressIndicator() : SizedBox(),
//       ),
//     );
//   }
// }
