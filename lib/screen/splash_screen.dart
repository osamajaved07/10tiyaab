// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:fyp_1/screen/onboarding_screen.dart';
import 'package:fyp_1/screen/selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  Future<void> navigateToNextScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isOnboardingCompleted = prefs.getBool('isOnboardingCompleted');

    // Delay for 4 seconds
    await Future.delayed(Duration(seconds: 4));

    if (isOnboardingCompleted ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserSelection()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateToNextScreen(context);

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
