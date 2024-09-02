// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_super_parameters, unused_field, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';

import '../../controllers/user_auth_controller.dart';

class PhoneNumberInputPage extends StatefulWidget {
  const PhoneNumberInputPage({Key? key}) : super(key: key);

  @override
  State<PhoneNumberInputPage> createState() => _PhoneNumberInputPageState();
}

class _PhoneNumberInputPageState extends State<PhoneNumberInputPage> {
  final AuthController _authController = Get.find<AuthController>();
  TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void _submitPhoneNumber() {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      String phoneNumber = _phoneController.text.trim();
      // Call the necessary function to handle phone number submission
      _authController.addPhoneNumber(phoneNumber);

      print('Valid phone number: +92$phoneNumber');
    } else {
      Get.snackbar('Error', 'Please enter a valid phone number',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios_new,
        //     color: ttextColor,
        //   ),
        //   onPressed: () {
        //     Get.back(); // Navigate back
        //   },
        // ),
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
                  SizedBox(height: 20),
                  Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your phone number below.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  _phoneNumberField(),
                  SizedBox(height: 20),
                  _nextButton(context),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _phoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        } else if (!RegExp(r'^[3]\d{9}$').hasMatch(value)) {
          return 'Enter your valid phone number';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: '3XXXXXXXXX',
        labelText: 'Phone Number',
        prefixText: '+92',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return GestureDetector(
      onTap: _submitPhoneNumber,
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
}
