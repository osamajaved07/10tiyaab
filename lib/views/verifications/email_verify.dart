// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';

import '../../controllers/user_auth_controller.dart';

class EmailVerification extends StatefulWidget {
  // final SharedPreferences prefs;
  const EmailVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final UserAuthController _authController = Get.find<UserAuthController>();
  TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void _showconfirmmessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to go back?'),
              SizedBox(height: 8.0),
              Text(
                'If you go back, all save credentials will be deleted',
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Get.offNamed("/userregister"); // Navigate back
              },
            ),
          ],
        );
      },
    );
  }

  void email() {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      String email = _emailController.text.trim();
      _authController.addEmail(email);

      // If the form is valid and the email field is not empty, proceed with further processing
      print('Valid email: $email');
      // Get.toNamed("/verify");
    } else {
      Get.snackbar('Error', 'Please fill all the required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      //  extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leadingWidth: 100, // Adjust width to fit the content
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: ttextColor,
              ),
              onPressed: () {
                // Navigate back
                _showconfirmmessage();
              },
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  // Navigate back
                  _showconfirmmessage();
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors
                        .black, // Set the color to match the app bar's theme
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 24),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight / 20),
                  Center(
                    child: Image.asset(
                      "assets/images/logo1.png",
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.2,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Email Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We need to register your email before getting started!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: _emailField(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _verifyButton(context),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
            .hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Email',
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  GestureDetector _verifyButton(BuildContext context) {
    return GestureDetector(
      onTap: email,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: tPrimaryColor, borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text(
            "Send code",
            style: TextStyle(
                color: ttextColor,
                fontSize: 20.0,
                fontFamily: 'Poppins1',
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
