// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/custom_dialog.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/user_auth_controller.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({
    super.key,
  });

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final UserAuthController _authController = Get.find<UserAuthController>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  bool _isLoading = true;
// To show loader while data is being fetched
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authController.fetchUserProfile();
      if (userData != null) {
        setState(() {
          _nameController.text = userData['username'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendFeedback() async {
    final feedbackMessage = _messageController.text.trim();

    if (feedbackMessage.isNotEmpty) {
      setState(() {});
      _isLoading = false;
      try {
        await _authController.sendFeedback(feedbackMessage);
        // successSnackbar(
        //   'Success',
        //   'Message sent successfully',
        // );
        _messageController.clear();
      } catch (e) {
        print('Error sending your message: $e');
        // errorSnackbar(
        //   'Error',
        //   'Failed to send your message. Please try again.',
        // );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      errorSnackbar(
        'Error',
        'Please enter your message',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        backgroundColor: tSecondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Contact Us",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: tPrimaryColor),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Loading your details...")
                ],
              ),
            ) // Show loader while data is being fetched
          : LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Text(
                            "Contact us for any queries",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.046,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                                color: ttextColor, fontWeight: FontWeight.w300),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          child: TextField(
                            controller: _emailController,
                            style: TextStyle(
                                color: ttextColor, fontWeight: FontWeight.w300),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: 'Email',
                            ),
                            enabled: false, // Email is not editable
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          child: TextField(
                            controller: _messageController,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Message',
                              hintText: "Type your message here...",
                              hintStyle: TextStyle(
                                color: Colors
                                    .grey.shade600, // Adjust hint text color
                                fontSize: 16, // Adjust font size of hint
                              ),
                              filled: true, // Enable background color
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey
                                      .shade400, // Border color for enabled state
                                  width: 1.5, // Adjust border thickness
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      tPrimaryColor, // Border color when focused
                                  width: 2.0, // Thicker border when focused
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors
                                      .redAccent, // Border color for error state
                                  width: 1.5,
                                ),
                              ),
                            ),
                            // enabled: false, // Email is not editable
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          child: SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.06,
                            child: ElevatedButton(
                              onPressed: () {
                                _sendFeedback();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF04BEBE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Send',
                                style: TextStyle(
                                  color: ttextColor,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBarWidget(
        initialIndex: 3,
      ),
    );
  }
}
