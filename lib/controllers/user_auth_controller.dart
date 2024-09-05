// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, avoid_print, prefer_const_constructors, await_only_futures

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  // final ApiService apiService =
  //     ApiService('https://fyp-project-zosb.onrender.com');

  final String baseUrl = 'https://fyp-project-zosb.onrender.com';
  String? user_id; // Nullable user_id to be set after registration
  String? accessToken;
  String? _refreshToken;

  // Set access token (you might want to set it during login or some other flow)
  void setAccessToken(String token) {
    accessToken = token;
  }

  // Set refresh token
  void setRefreshToken(String token) {
    _refreshToken = token;
  }

  // Logout function
  Future<void> logout() async {
    if (accessToken == null) {
      Get.snackbar('Error', 'Access token is not available',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.dialog(
      Center(child: CircularProgressIndicator(color: tPrimaryColor)),
      barrierDismissible: false,
    );
    try {
       final String url = '$baseUrl/accounts/logout/';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

// Log the headers to check if the Authorization header contains the access token
      print('Request Headers: $headers');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      // final response = await http.post(
      //   Uri.parse('$baseUrl/accounts/logout/'),
      //   headers: {
      //     'Authorization': 'Bearer $accessToken!',
      //     'Content-Type': 'application/json',
      //   },
      // );
      Get.back(); // Hide the circular progress indicator

      if (response.statusCode == 200) {
        // Clear access token and user_id
        accessToken = null;
        _refreshToken = null; // Also clear refresh token
        user_id = null;

        // Navigate to login screen or home screen
        Get.offAllNamed('/userLogin');
        Get.snackbar('Success', 'Successfully logged out',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print('Failed to logout: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to logout. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> refreshToken() async {
    if (_refreshToken == null) {
      Get.snackbar('Error', 'Refresh token is not available',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/refresh-token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': _refreshToken}),
      );
      print('Refresh token response status: ${response.statusCode}');
      print('Refresh token response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'];
        setAccessToken(newAccessToken); // Store new access token
      } else if (response.statusCode == 401) {
        // Handle token blacklisting
        Get.snackbar('Error', 'Session expired. Please log in again.',
            backgroundColor: Colors.red, colorText: Colors.white);
        // Redirect to login screen
        Get.offAllNamed('/userLogin');
      } else {
        Get.snackbar('Error', 'Failed to refresh token',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Fetch user profile function
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    if (accessToken == null) {
      Get.snackbar('Error', 'Access token is not available',
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }

    try {
      // final response = await http.get(
      //   Uri.parse('$baseUrl/accounts/profile/'),
      //   headers: {
      //     'Authorization': 'Bearer $accessToken!',

      //   },
      // );
      final String url = '$baseUrl/accounts/profile/';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

// Log the headers to check if the Authorization header contains the access token
      print('Request Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print("$accessToken");
      print('Fetch user profile response status: ${response.statusCode}');
      print('Fetch user profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        if (userData['profile_pic'] != null) {
        String profilePicUrl = userData['profile_pic'];
        if (!profilePicUrl.startsWith('https')) {
          profilePicUrl = '$baseUrl$profilePicUrl';
        }
        userData['profile_pic'] = profilePicUrl;
      }
        return userData;
        // if (userData.containsKey('first_name') &&
        //     userData.containsKey('last_name') &&
        //     userData.containsKey('email') &&
        //     userData.containsKey('phone_no') &&
        //     userData.containsKey('profile_pic')) {
        //   return userData;
        // } else {
        //   Get.snackbar('Error', 'Unexpected profile data format',
        //       backgroundColor: Colors.red, colorText: Colors.white);
        //   return null;
        // }
      } else if (response.statusCode == 401) {
        // Handle token refresh if the response indicates the token is expired
        await refreshToken();
        // Retry fetching user profile
        return await fetchUserProfile();
      } else {
        Get.snackbar('Error',
            'Failed to load user profile: ${response.statusCode} - ${response.body}',
            backgroundColor: Colors.red, colorText: Colors.white);
        print(
            'Failed response: ${response.body}'); // Log the response body for debugging
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Exception: $e'); // Log the exception
      return null;
    }
  }

  String formatErrorMessage(Map<String, dynamic> errorResponse) {
    StringBuffer formattedMessage = StringBuffer();
    errorResponse.forEach((key, value) {
      if (value is List) {
        String message = value.join(', ');
        // Customizing error messages based on specific keywords
        if (message
            .contains('custom user model with this username already exists')) {
          formattedMessage.writeln(
              'Username is already in use, please use a unique username.');
        } else if (message
            .contains('custom user model with this email already exists')) {
          formattedMessage.writeln(
              'Email is already in use, please use a different email.');
        } else {
          formattedMessage.writeln(message);
        }
      } else {
        formattedMessage.writeln(value.toString());
      }
    });
    return formattedMessage.toString().trim();
  }

  Future<void> addPhoneNumber(String phoneNumber) async {
    if (user_id == null) {
      Get.snackbar('Error', 'User ID is not set.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/customer/add-phone-number/$user_id/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone_no': phoneNumber,
        }),
      );
      Get.back();
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Phone number added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(Duration(seconds: 1), () {
          Get.toNamed("/userregisterfinal");
        });
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to add phone number. Please try again.';
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addEmail(String email) async {
    if (user_id == null) {
      Get.snackbar('Error', 'User ID is not set.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
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
      Get.back();

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Adding a slight delay to ensure the Snackbar is visible
        Future.delayed(Duration(seconds: 1), () {
          Get.offAllNamed("/verify");
        });
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to send OTP. Please try again.';
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
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
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/resend-otp/$user_id/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Get.back();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP resend to your email',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to resend OTP. Please try again.';
        }
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
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
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
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
      Get.back();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Email verified successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed("/userphone");
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to verify OTP. Please try again.';
        }
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
        print("${response.body}");
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> register(String username, String firstName, String lastName,
      String password, String confirmPassword) async {
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    ); // Show the circular progress indicator
    try {
      final registerResponse = await http.post(
        Uri.parse('$baseUrl/accounts/customer/signup/'),
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
      Get.back(); // Hide the circular progress indicator
      if (registerResponse.statusCode == 201) {
        final Map<String, dynamic> responseData =
            jsonDecode(registerResponse.body);

        final dynamic userId = responseData['user_id'];
        if (userId is int) {
          user_id = userId.toString(); // Convert integer to string if necessary
        } else if (userId is String) {
          user_id = userId;
        } else {
          throw Exception('Unexpected user_id type');
        }

        final loginResponse = await http.post(
          Uri.parse('$baseUrl/accounts/login/'),
          body: jsonEncode({
            'username': username,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'},
        );
        if (loginResponse.statusCode == 200) {
          final Map<String, dynamic> loginData = jsonDecode(loginResponse.body);
          final accessToken = loginData['access_token'];
          final refreshToken = loginData['refresh'];

          // Store the access token
          setAccessToken(accessToken);
          setRefreshToken(refreshToken);

          Get.snackbar('Success', 'Registration successful',
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAllNamed(
              '/phoneverify'); // Change '/homepage' to the desired route
        } else {
          // Handle login failure
          Get.snackbar('Error', 'Login after registration failed.',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        // Handle different status codes
        String errorMessage;
        if (registerResponse.statusCode == 400) {
          // Parse the response body for specific errors
          final Map<String, dynamic> errorResponse =
              jsonDecode(registerResponse.body);
          errorMessage = formatErrorMessage(
              errorResponse); // Concatenate all error messages
        } else {
          errorMessage = 'Registration failed. Please try again.';
        }
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
        print("${registerResponse.body}");
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      print("$e");
    }
  }

  Future<void> login(String username, String password) async {
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      Get.back();
      if (response.statusCode == 200) {
        final Map<String, dynamic> loginData = jsonDecode(response.body);
        final accessToken = loginData['access_token'];
        final refreshToken = loginData['refresh'];
        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');

        setAccessToken(accessToken);
        setRefreshToken(refreshToken);
        // user_id = loginData['user_id'].toString(); // Update user_id
        final dynamic userId = loginData['user_id'];
        if (userId is int) {
          user_id = userId.toString(); // Convert integer to string if necessary
        } else if (userId is String) {
          user_id = userId;
        } else {
          throw Exception('Unexpected user_id type');
        }
        Get.snackbar('Success', 'Welcome back.',
            backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to home screen or desired page
        Get.offAllNamed("/homescreen");
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(
              errorResponse); // Concatenate all error messages
        } else {
          errorMessage = 'Login failed. Please try again.';
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
        print("${response.body}");
      }
    } catch (e) {
      Get.back();
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
