// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/controllers/sp_auth_controller.dart';
import 'package:fyp_1/utils/colors.dart';
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
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  Future<void> _startSplashScreenTimer() async {
    await Future.delayed(Duration(seconds: 4)); // Wait for 4 seconds
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isOnboardingCompleted =
          prefs.getBool('isOnboardingCompleted') ?? false;
      final String? userType = await _secureStorage.read(key: 'user_type');

      final results = await Future.wait(
          [_authController.isLoggedIn(), _spauthController.isspLoggedIn()]);

      final bool isLoggedin = results[0];
      final bool isspLoggedin = results[1];

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
    } catch (e) {
      print("Error during login check: $e");
      Get.offAllNamed('/userLogin');
    } finally {
      setState(() {
        _isLoading = false; // Hide progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04BEBE),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo1.png',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: tPrimaryColor,
                    backgroundColor: Colors.blueGrey,
                  ),
                  SizedBox(height: 16),
                  Text('Loading...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
