// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/colors.dart';

class Final extends StatefulWidget {
  const Final({super.key});

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );

    // Start the animation
    _animationController.forward();

    // Redirect to the home screen after 15 seconds
    Future.delayed(Duration(seconds: 4), () {
      Get.offAllNamed ("/homescreen");
    });

    // Prevent back navigation from the home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.key.currentState?.didChangeDependencies();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final screenHeight = constraints.maxHeight;
      return SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      tPrimaryColor,
                      tPrimaryColor.withOpacity(0.4),
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 3),
                height: screenHeight / 1.5,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: tlightPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),
              Positioned(
                top: screenHeight / 20,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Center(
                          child: Image.asset(
                        "assets/images/logo1.png",
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                      )),
                      SizedBox(
                        height: 4.0,
                      ),
                      Material(
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 28),
                          width: screenWidth,
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Lottie.asset('assets/lottie/verify.json',
                                    width: screenWidth * 0.1,
                                    height: screenHeight * 0.14,
                                    fit: BoxFit.contain,
                                   ),
                                Text(
                                  'Your account is ready to use. You will be redirected to the Home Page in a few seconds.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      height: 1.6,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: screenHeight * 0.04,),
                                Image.asset(
                                  "assets/images/infinity.png",
                                  width: screenWidth * 0.1,
                                  height: screenHeight * 0.06,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
