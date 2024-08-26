// ignore_for_file: unused_local_variable, prefer_const_constructors, use_super_parameters, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  Future<void> _showLoadingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/loading.json', width: 200, height: 200),
              SizedBox(height: 20),
              Text("Verifying...", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );

    // Simulate a network call
    await Future.delayed(Duration(seconds: 3));

    Navigator.pop(context); // Remove the loading dialog

    _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/verify.json', width: 400, height: 400),
              SizedBox(height: 20),
              Text("Verification Complete!", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );

    // Simulate some delay
    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // Remove the success dialog

    // Navigate to the home screen
    Get.offNamed("/homescreen");
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 24, // Increased size
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(120, 120, 121, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(245, 255, 255, 1),
      ),
    );

    return Scaffold(
      backgroundColor: tSecondaryColor,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: ((context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight / 10),
                Image.asset(
                  "assets/images/logo1.png",
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter 6 digits verification code we have sent to your phone number",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await _showLoadingDialog();
                    },
                    child: Text(
                      "Verify Phone Number",
                      style: TextStyle(
                        color: ttextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offNamed("/phoneverify");
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      })),
    );
  }
}
