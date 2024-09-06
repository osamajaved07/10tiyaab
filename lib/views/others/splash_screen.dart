// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fyp_1/views/others/onboarding_screen.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 4));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    if (isOnboardingCompleted) {
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
