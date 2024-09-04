// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, equal_keys_in_map, unnecessary_import, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/views/verifications/email_verify.dart';
import 'package:fyp_1/views/verifications/final.dart';
import 'package:fyp_1/views/verifications/phoneinput.dart';
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
   final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AuthController authController = Get.put(AuthController());
  final bool isLoggedIn = await authController.isLoggedIn();
  final bool hasSeenSplash = await _hasSeenSplashScreen();
   final String? lastScreen = prefs.getString('last_screen');
  runApp(MyApp(isLoggedIn: isLoggedIn, lastScreen: lastScreen,
  hasSeenSplash: hasSeenSplash,));
}

Future<bool> _hasSeenSplashScreen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenSplash') ?? false;
}

Future<void> _setHasSeenSplashScreen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenSplash', true);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
   final bool hasSeenSplash;
    final String? lastScreen;

  // final SharedPreferences prefs;
  const MyApp({super.key, required this.isLoggedIn, this.lastScreen, required this.hasSeenSplash});

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
       home: hasSeenSplash ? getHomeScreen() : SplashScreen(),
      getPages: [
        GetPage(name: '/selection', page: () => UserSelection()),
        GetPage(
            name: '/professionalregister',
            page: () => ProfessionalRegistration()),
        GetPage(name: '/professionalLogin', page: () => MazdoorLogin()),
        GetPage(
            name: '/userregister',
            page: () => UserRegister(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userLogin',
            page: () => UserLogin(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/phoneverify',
            page: () => EmailVerification(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/verify',
            page: () => MyVerify(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userphone',
            page: () => PhoneNumberInputPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userregisterfinal',
            page: () => Final(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/homescreen',
            page: () => UserHomeScreen(),
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
    Widget getHomeScreen() {
    return FutureBuilder<bool>(
      future: _hasSeenSplashScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data ?? false) {
            return UserHomeScreen(); // or any other screen based on your logic
          } else {
            return SplashScreen(); // should not reach here if logic is correct
          }
        }
        return Center(child: CircularProgressIndicator()); // loading state
      },
    );
  }
}
