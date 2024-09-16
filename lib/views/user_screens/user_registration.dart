// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new, prefer_final_fields, unused_element, unused_local_variable, unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/models/user__signup_model.dart'; // Importing the signup model
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final UserAuthController _authController = Get.put(UserAuthController());

  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool ispasswordVisible = false;

  // Controllers
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void register() async {
    if (_formkey.currentState!.validate()) {
      String username = _userNameController.text.trim();
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      } else {
        _authController.register(
            username, firstName, lastName, password, confirmPassword);
      }
    } else {
      Get.snackbar('Error', 'Please fill all the required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final screenHeight = constraints.maxHeight;
      return SingleChildScrollView(
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                        width: screenWidth,
                        decoration: BoxDecoration(
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
                                _userNameField(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                8.0), // Adds spacing to the right
                                        child: _firstNameField(),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left:
                                                8.0), // Adds spacing to the left
                                        child: _lastNameField(),
                                      ),
                                    ),
                                  ],
                                ),
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
            "Register",
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
      controller: _confirmPasswordController,
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
      controller: _passwordController,
      obscureText: !isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters';
        } else if (!RegExp(
                r'^(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&])[a-z\d@$!%*#?&]{8,}$')
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

  TextFormField _userNameField() {
    return TextFormField(
      controller: _userNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Username',
        labelText: 'Username',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField _firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your first name';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Firstname',
        labelText: 'Firstname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField _lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your last name';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Lastname',
        labelText: 'Lastname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}
