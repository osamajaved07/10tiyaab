// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new, prefer_final_fields, unused_local_variable, unused_element, sized_box_for_whitespace, unused_import, unnecessary_import, deprecated_member_use, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/models/login_model.dart';
import 'package:fyp_1/services/firebase_auth_service.dart';
import 'package:fyp_1/views/others/home.dart';
import 'package:fyp_1/views/sp_screens/sp_registration.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({
    super.key,
  });

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final UserAuthController _authController = Get.find<UserAuthController>();
  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isButtonEnabled = false;
  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _namecontroller.addListener(_validateFields);
    _passwordcontroller.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      isButtonEnabled = _namecontroller.text.isNotEmpty &&
          _passwordcontroller.text.isNotEmpty;
    });
  }

  void _login() async {
    if (_formkey.currentState!.validate()) {
      String username = _namecontroller.text.trim();
      String password = _passwordcontroller.text.trim();

      // Call the login method from AuthController
      await _firebaseAuthService.loginUser(username, password);
      await _authController.login(username, password);
      print("User loggedIn successfully");
    } else {
      Get.snackbar('Error', 'Please fill all the required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return SingleChildScrollView(
            child: Container(
              height: screenHeight,
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
                    right: 0, // Center horizontally
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/logo1.png",
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                          SizedBox(
                            height: 16.0,
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
                                  key: _formkey,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: tlargefontsize(context),
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      _nameField(),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      _passwordField(),
                                      SizedBox(
                                        height: 32.0,
                                      ),
                                      _loginButton(context),
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
                                "Don't have an account?",
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
                                    Get.toNamed("/userregister");
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87),
                                  )),
                            ],
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

  GestureDetector _loginButton(BuildContext context) {
    return GestureDetector(
      onTap: isButtonEnabled ? _login : null,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: tPrimaryColor, borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(
            "LOGIN",
            style: TextStyle(
                color: ttextColor,
                fontSize: tmidfontsize(context),
                fontFamily: 'Poppins1',
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Material _passwordField() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: TextFormField(
        controller: _passwordcontroller,
        obscureText: !isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password cannot be empty';
          } else {
            return null;
          }
        },
        // obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          hintText: 'Password',
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible; // Toggle visibility
              });
            },
          ),
        ),
      ),
    );
  }

  Material _nameField() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: TextFormField(
        controller: _namecontroller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name cannot be empty';
          }
          // else if (!RegExp(r'^([A-Z][a-z]*)( [A-Z][a-z]*)*$').hasMatch(value)) {
          //   return 'Names must start with capital letter and \n contain only letters and spaces.';
          // }
          else {
            return null;
          }
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'Name',
            labelText: 'Name',
            prefixIcon: Icon(Icons.person_outline)),
      ),
    );
  }
}
