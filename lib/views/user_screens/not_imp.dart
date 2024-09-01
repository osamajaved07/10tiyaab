// lib/controllers/auth_controller.dart
// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_1/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService apiService =
      ApiService('https://fyp-project-zosb.onrender.com');

  void register(String username, String firstName, String lastName,
      String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://fyp-project-zosb.onrender.com/accounts/customer/signup/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registration successful',
            backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to next screen
        Get.toNamed("/phoneverify");
      } else {
        // Show detailed error message
        Get.snackbar('Error', 'Registration failed: ${response.body}',
            backgroundColor: Colors.red, colorText: Colors.white);
        print("${response.body}");
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
          print("$e");
    }
  }

  Future<bool> isLoggedIn() async {
    // Implement your logic to check if the user is logged in
    return false;
  }
}