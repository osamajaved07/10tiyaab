// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/user_screen/user_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const ContactUsScreen({super.key, required this.prefs});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String name = "", email = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      name = widget.prefs.getString('name') ?? 'User';
      _nameController.text = name;
      email = widget.prefs.getString('email') ?? '123@gmail.com';
      _emailController.text = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Email',
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                    ),
                    enabled: false, // Email is not editable
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: '',
                      hintText: "Type your message here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // enabled: false, // Email is not editable
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle update action
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
