// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new, prefer_final_fields, unused_local_variable, unused_element, sized_box_for_whitespace, unused_import, unnecessary_import, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_1/screen/home_screen.dart';
import 'package:fyp_1/mazdoor_screens/mazdoor_registration_screen.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  final SharedPreferences prefs;
  const UserLogin({super.key, required this.prefs});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  String name = "", password = "", confirmpassword = "";
  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool ispasswordVisible = false;
  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();

  void login() {
    if (_formkey.currentState!.validate()) {
      String enteredName = _namecontroller.text.trim();
      String enteredPassword = _passwordcontroller.text.trim();

      // Retrieve saved email and password from SharedPreferences
      String savedName = widget.prefs.getString('name') ?? '';
      String savedPassword = widget.prefs.getString('password') ?? '';

      if (enteredName == savedName && enteredPassword == savedPassword) {
        // Clear text fields
        _namecontroller.clear();
        _passwordcontroller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Get.toNamed("/homescreen");
      } else {
        // Show error message if credentials do not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid name or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leadingWidth: 100, // Adjust width to fit the content
      //   leading: Row(
      //     children: [
      //       IconButton(
      //         icon: Icon(
      //           Icons.arrow_back_ios_new,
      //           color: ttextColor,
      //         ),
      //         onPressed: () {
      //           Get.offNamed("/selection");
      //           // Navigate back
               
      //         },
      //       ),
      //       Flexible(
      //         child: GestureDetector(
      //           onTap: () {
                  
      //            Get.offNamed("/selection"); // Navigate back
                  
      //           },
      //           child: Text(
      //             "Back",
      //             style: TextStyle(
      //               color: Colors
      //                   .black, // Set the color to match the app bar's theme
      //               fontSize: 18,
      //             ),
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
                                          fontSize: 24,
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
      }),
    );
  }

  GestureDetector _loginButton(BuildContext context) {
    return GestureDetector(
      onTap: login,
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
            "LOGIN",
            style: TextStyle(
                color: ttextColor,
                fontSize: 18.0,
                fontFamily: 'Poppins1',
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      controller: _passwordcontroller,
      obscureText: !isPasswordVisible,
      validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Password cannot be empty';
      }  else {
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
    );
  }

  TextFormField _nameField() {
    return TextFormField(
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
    );
  }
}
