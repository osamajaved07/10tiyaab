// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, avoid_print

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_1/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService apiService =
      ApiService('https://fyp-project-zosb.onrender.com');

  final String baseUrl = 'https://fyp-project-zosb.onrender.com';
  // final String user_id = '13'; // Example user ID, adjust as needed
  String? user_id; // Nullable user_id to be set after registration

  Future<void> addEmail(String email) async {
    if (user_id == null) {
      Get.snackbar('Error', 'User ID is not set.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/customer/add-email/$user_id/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Adding a slight delay to ensure the Snackbar is visible
        Future.delayed(Duration(seconds: 1), () {
          Get.toNamed("/verify");
        });
      } else {
        Get.snackbar(
          'Error',
          'Failed to send OTP: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendOtp() async {
    if (user_id == null) {
      Get.snackbar('Error', 'User ID is not set.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/resend-otp/$user_id/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP resend to your email',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to resend OTP: ${response.body}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (user_id == null) {
      Get.snackbar('Error', 'User ID is not set.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/verify/$user_id/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Email verified successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed("/homescreen"); // Navigate to the home screen
      } else {
        Get.snackbar('Error', 'Failed to verify OTP: ${response.body}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic userId = responseData['user_id'];
        if (userId is int) {
          user_id = userId.toString(); // Convert integer to string if necessary
        } else if (userId is String) {
          user_id = userId;
        } else {
          throw Exception('Unexpected user_id type');
        }
        Get.snackbar('Success', 'Registration successful',
            backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to next screen
        Get.toNamed("/phoneverify");
      } else {
        // Handle different status codes
        String errorMessage;
        if (response.statusCode == 400) {
          // Parse the response body for specific errors
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage =
              errorResponse.values.join(', '); // Concatenate all error messages
        } else {
          errorMessage = 'Registration failed. Please try again.';
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
        print("${response.body}");
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      print("$e");
    }
  }

  Future<bool> isLoggedIn() async {
    // Implement your logic to check if the user is logged in
    return false;
  }
}
