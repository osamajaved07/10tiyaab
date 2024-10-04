// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, unnecessary_import, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_1/main.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tlightPrimaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return Stack(
            children: [
              Positioned(
                top: screenHeight / 8,
                left: screenWidth / 2 -
                    (screenWidth * 0.225), // Center horizontally
                child: Image.asset(
                  "assets/images/logo1.png",
                  width: screenWidth * 0.5, // Adjusted width for responsiveness
                  height:
                      screenHeight * 0.28, // Adjusted height for responsiveness
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 65, 64, 64)
                                .withOpacity(0.5), // Shadow color
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: Offset(0, 3), // Shadow position (x, y)
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      height: screenHeight / 2.66,
                      child: Column(
                        children: [
                          Text(
                            "Choose to continue",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16), // Add some space
                          Text(
                            "Please select any option to continue.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 50), // Adjust spacing as needed
                          SizedBox(
                            width: screenWidth *
                                0.8, // Adjusted width for responsiveness
                            child: ElevatedButton(
                              onPressed: () {
                                // MazdoorIdStateChecker();
                                Get.toNamed('/professionalLogin');
                                // Navigator.pushNamed(context, '/professionalLogin');
                              },
                              child: Text(
                                "Continue as Service Provider",
                                style: TextStyle(
                                  color: ttextColor,
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins1',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: tPrimaryColor, // Text color
                                shadowColor: Colors.grey, // Shadow color
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: screenWidth *
                                0.8, // Adjusted width for responsiveness
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/userLogin');
                              },
                              child: Text(
                                "Continue as Customer",
                                style: TextStyle(
                                  color: ttextColor,
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins1',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: tPrimaryColor, // Text color
                                shadowColor: Colors.grey, // Shadow color
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
