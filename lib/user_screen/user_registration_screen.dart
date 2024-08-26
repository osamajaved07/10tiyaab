// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new, prefer_final_fields, unused_element, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:fyp_1/phone_verification/phone_verification.dart';
import 'package:fyp_1/mazdoor_screens/mazdoor_login_screen.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRegister extends StatefulWidget {
  final SharedPreferences prefs;
  const UserRegister({super.key, required this.prefs});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  String name = "", password = "", confirmpassword = "";
  // String? selectedGender;
  // final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool ispasswordVisible = false;
  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _confirmpasswordcontroller =
      new TextEditingController();

  void register() {
    if (_formkey.currentState!.validate()) {
      String name = _namecontroller.text.trim();
      String password = _passwordcontroller.text.trim();
      String confirmPassword = _confirmpasswordcontroller.text.trim();
      if (password != confirmPassword) {
        // Show Snackbar message if passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Exit the method
      }

      // Save user data to SharedPreferences
      widget.prefs.setString('name', name);
      widget.prefs.setString('password', password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credentials saved successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to next screen or perform any other action
      
      Get.toNamed("/phoneverify");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Text(
                                    "Register",
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

                                  _emailField(),
                                  SizedBox(
                                    height: 20.0,
                                  ),

                                  _passwordField(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _confirmpasswordField(),
                                  SizedBox(
                                    height: 32.0,
                                  ),
                                  _registerButton(context),
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
                                // Get.off(() => LoginScreen(prefs: widget.prefs));
                                Get.offNamed("/userLogin");
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

  GestureDetector _registerButton(BuildContext context) {
    return GestureDetector(
      onTap: register,
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
            "Next",
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

  TextFormField _confirmpasswordField() {
    return TextFormField(
      controller: _confirmpasswordcontroller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters';
        } else {
          return null;
        }
      },
      obscureText: !ispasswordVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Confirm password',
        labelText: 'Confirm password',
        prefixIcon: Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            ispasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              ispasswordVisible = !ispasswordVisible; // Toggle visibility
            });
          },
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
        return 'Please enter password';
      } else if (value.length < 8) {
        return 'Password must be at least 8 characters';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&])[a-z\d@$!%*#?&]{8,}$')
          .hasMatch(value)) {
        return 'Password must contain at least one letter,\none number, and one special character';
      } else {
        return null;
      }
    },
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

  TextFormField _emailField() {
    return TextFormField(
      controller: _emailcontroller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          hintText: '123@gmail.com',
          labelText: 'Email',
          prefixIcon: Icon(Icons.mail_outline_rounded)),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      controller: _namecontroller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        } else if (!RegExp(r'^([A-Z][a-z]*)( [A-Z][a-z]*)*$').hasMatch(value)) {
          return 'Names must start with capital letter and \n contain only letters and spaces.';
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          hintText: 'John Doe',
          labelText: 'Name',
          prefixIcon: Icon(Icons.person_outline)),
    );
  }
}
