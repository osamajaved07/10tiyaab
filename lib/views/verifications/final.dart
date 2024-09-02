// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class Final extends StatefulWidget {
  const Final({super.key});

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> {
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
                            child: Form(
                             
                              child: Column(
                                children: [
                                  Icon(FeatherIcons.info, size: 56),

                                  SizedBox(
                                      height:
                                          8), // Adds some spacing between the icon and the text

                                  SizedBox(
                                      height:
                                          16), // Adds some spacing before the next element
                                  Text(
                                    'Registration for Service Provider is currently handled by our main office. Please visit our main branch or contact our representative to get registered.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      height: 1.6,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.offNamed("/professionalLogin");
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87),
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    })
    );
  }
}