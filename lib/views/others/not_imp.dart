import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/controllers/sp_auth_controller.dart';
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

  bool _isLoading = false; // To track loading state after 8 seconds

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
    _performBackgroundTasks();
  }

  // Timer for splash screen (fixed duration of 8 seconds)
  void _startSplashScreenTimer() async {
    await Future.delayed(Duration(seconds: 8)); // 8-second splash screen
    if (mounted) {
      setState(() {
        _isLoading = true; // Show loading indicator if tasks are not complete
      });
    }
  }

  // Perform background tasks during splash screen
  Future<void> _performBackgroundTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isOnboardingCompleted =
          prefs.getBool('isOnboardingCompleted') ?? false;
      final String? userType = await _secureStorage.read(key: 'user_type');

      final results = await Future.wait([
        _authController.isLoggedIn(),
        _spauthController.isspLoggedIn(),
      ]);
      final bool isLoggedin = results[0];
      final bool isspLoggedin = results[1];

      // Check if splash screen is still active
      if (mounted) {
        if (isOnboardingCompleted) {
          if (isLoggedin) {
            print('Type: $userType');
            Get.offAllNamed("/homescreen");
          } else if (isspLoggedin) {
            print('Type: $userType');
            Get.offAllNamed("/sphome");
          } else {
            Get.offAllNamed("/selection");
          }
        } else {
          Get.offAllNamed('/onboarding_screen');
        }
      }
    } catch (e) {
      if (mounted) {
        // If there was an error, navigate to the login screen
        print("Failed to retrieve profile after token refresh: $e");
        Get.offAllNamed('/userLogin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04BEBE),
      body: Stack(
        children: [
          // Splash Screen Content
          Center(
            child: Image.asset(
              'assets/images/logo1.png',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),

          // Show progress indicator if background tasks are still ongoing after 8 seconds
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
