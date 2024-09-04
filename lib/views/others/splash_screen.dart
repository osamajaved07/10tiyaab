// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fyp_1/views/others/onboarding_screen.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

   Future<void> _setHasSeenSplashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenSplashScreen', true);
  }

  Future<void> navigateToNextScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenSplashScreen = prefs.getBool('hasSeenSplashScreen');
    bool? isOnboardingCompleted = prefs.getBool('isOnboardingCompleted');

    // Delay for 4 seconds
    await Future.delayed(Duration(seconds: 4));

     if (hasSeenSplashScreen ?? false) {
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
    } else {
      await _setHasSeenSplashScreen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserSelection()),
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
