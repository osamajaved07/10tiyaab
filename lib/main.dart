// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, equal_keys_in_map, unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'package:fyp_1/phone_verification/phone_verification.dart';
import 'package:fyp_1/phone_verification/verification_final.dart';
import 'package:fyp_1/screen/home_screen.dart';
import 'package:fyp_1/mazdoor_screens/mazdoor_login_screen.dart';
import 'package:fyp_1/mazdoor_screens/mazdoor_registration_screen.dart';
import 'package:fyp_1/screen/selection_screen.dart';
import 'package:fyp_1/screen/splash_screen.dart';
import 'package:fyp_1/user_screen/contactus_screen.dart';
import 'package:fyp_1/user_screen/edit_profile_screen.dart';
import 'package:fyp_1/user_screen/user_homepage.dart';
import 'package:fyp_1/user_screen/user_login_screen.dart';
import 'package:fyp_1/user_screen/user_registration_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({required this.prefs, super.key});

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
                  prefs: prefs,
                )),
        GetPage(
            name: '/professionalLogin',
            page: () => MazdoorLogin(
                  prefs: prefs,
                )),
        GetPage(
            name: '/userregister',
            page: () => UserRegister(
                  prefs: prefs,
                )),
        GetPage(
            name: '/userLogin',
            page: () => UserLogin(
                  prefs: prefs,
                )),
        GetPage(
            name: '/phoneverify',
            page: () => PhoneVerification(
                  prefs: prefs,
                )),
        GetPage(name: '/verify', page: () => MyVerify()),
        GetPage(
            name: '/homescreen',
            page: () => UserHomeScreen(
                  prefs: prefs,
                ),
            transition: Transition.fadeIn),
        GetPage(
            name: '/editprofile',
            page: () => EditProfilePage(prefs: prefs,),
            transition: Transition.fadeIn),

            GetPage(
            name: '/contactus',
            page: () => ContactUsScreen(prefs: prefs,),
            transition: Transition.fadeIn),
      ],
    );
  }
}

class MazdoorIdStateChecker extends StatefulWidget {
  @override
  _MazdoorIdStateCheckerState createState() => _MazdoorIdStateCheckerState();
}

class _MazdoorIdStateCheckerState extends State<MazdoorIdStateChecker> {
  bool isLoading = true; // Loading indicator while checking user state

  @override
  void initState() {
    super.initState();
    checkUserState(); // Check user state when the widget initializes
  }

  Future<void> checkUserState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Check if user data exists
      bool userDataExists =
          prefs.containsKey('name') && prefs.containsKey('password');
      if (userDataExists) {
        // Navigate to home screen if user data exists
        Get.offNamed("/homescreen");
      } else {
        // Navigate to login screen if user data doesn't exist
        Get.offNamed("/professionalLogin");
      }
    } catch (e) {
      // Handle any errors that occur during the check
      print("Error checking user state: $e");
      // Optionally, navigate to an error screen or show an error message
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking user state
    return Scaffold(
      body: Center(
        child: isLoading ? CircularProgressIndicator() : SizedBox(),
      ),
    );
  }
}
