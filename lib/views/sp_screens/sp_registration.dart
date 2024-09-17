// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new, prefer_final_fields, unused_element, unused_local_variable, unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fyp_1/views/verifications/email_verify.dart';
import 'package:fyp_1/views/sp_screens/sp_login.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feather_icons/feather_icons.dart';

class ServiceProviderRegistration extends StatefulWidget {
  const ServiceProviderRegistration({
    super.key,
  });

  @override
  State<ServiceProviderRegistration> createState() =>
      _ServiceProviderRegistrationState();
}

class _ServiceProviderRegistrationState
    extends State<ServiceProviderRegistration> {
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
    }));
  }
}
