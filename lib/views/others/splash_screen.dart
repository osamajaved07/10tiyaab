// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, use_build_context_synchronously, unused_local_variable
import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/sp_auth_controller.dart';
import 'package:fyp_1/views/others/onboarding_screen.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/user_auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserAuthController _authController = Get.find<UserAuthController>();
  final SpAuthController _spauthController = Get.find<SpAuthController>();
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 4));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedin = await _authController.isLoggedIn();
    bool isspLoggedin = await _spauthController.isspLoggedIn();
    bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    if (isOnboardingCompleted) {
      if (isLoggedin) {
        Get.offAllNamed("/homescreen");
      } else if (isspLoggedin) {
        Get.offAllNamed("/sphome");
      } else {
        Get.offAllNamed("/selection");
      }
    } else {
      Get.offAllNamed('/onboarding_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    (context);

    return Scaffold(
      backgroundColor: Color(0xFF04BEBE),
      body: Center(
        child: Image.asset(
          'assets/images/Logo.png',
          width: 350,
          height: 350,
        ),
      ),
    );
  }
}
