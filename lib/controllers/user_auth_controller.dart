// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, avoid_print, prefer_const_constructors, await_only_futures, prefer_const_declarations, dead_code

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/custom_dialog.dart';

class UserAuthController extends GetxController {
  final String baseUrl = 'https://fyp-project-zosb.onrender.com';
  String? user_id; // Nullable user_id to be set after registration
  String? accessToken;
  String? _refreshToken;

  final _secureStorage = const FlutterSecureStorage();

  @override
  void onInit() async {
    super.onInit();
    await loadTokens();
    // isLoggedIn();
  }

  // Set access token (you might want to set it during login or some other flow)
  void setAccessToken(String token) async {
    accessToken = token;
  }

  // Set refresh token
  void setRefreshToken(String token) async {
    _refreshToken = token;
  }

  Future<void> loadTokens() async {
    accessToken = await _secureStorage.read(key: 'accessToken');
    _refreshToken = await _secureStorage.read(key: '_refreshToken');
  }

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'accessToken', value: accessToken);
    await _secureStorage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<void> updateUserInfo({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? profilePicPath,
  }) async {
    if (accessToken == null) {
      errorSnackbar(
        'Error',
        'Access token is not available',
      );
      return;
    }

    Get.dialog(
      Center(child: CircularProgressIndicator(color: tPrimaryColor)),
      barrierDismissible: false,
    );

    try {
      // Create the request body
      final Map<String, String> body = {
        'first_name': firstName,
        'last_name': lastName,
        'phone_no': phoneNumber,
      };

      // Update user info
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/accounts/profile/update/'),
      )
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..fields.addAll(body);

      // If a profile picture path is provided, add it to the request
      if (profilePicPath != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile_pic', profilePicPath));
      }

      // Send the request
      final response = await request.send();

      Get.back();

      if (response.statusCode == 200) {
        successSnackbar(
          'Success',
          'Profile updated successfully',
        );
        // Optionally refresh user profile
        await fetchUserProfile();
      } else {
        errorSnackbar(
          'Error',
          'Failed to update user information. Please try again.',
        );
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> sendFeedback(String feedback) async {
    if (accessToken == null) {
      errorSnackbar(
        'Error',
        'Access token is not available',
      );
      return;
    }

    Get.dialog(
      Center(child: CircularProgressIndicator(color: tPrimaryColor)),
      barrierDismissible: false,
    );
    final String url = 'https://fyp-project-zosb.onrender.com/contact/us/';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'message': feedback}),
      );
      Get.back();

      if (response.statusCode == 200) {
        successSnackbar('Success', 'Message sent successfully');
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ??
            'Failed to send your message';
        errorSnackbar(
            'Error', errorMessage); // Display detailed error if available
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  // Logout function
  Future<void> logout() async {
    if (accessToken == null) {
      errorSnackbar(
        'Error',
        'Access token is not available',
      );
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

      Get.back(); // Hide the circular progress indicator

      if (response.statusCode == 200) {
        accessToken = null;
        _refreshToken = null; // Also clear refresh token
        user_id = null;
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');

        // Navigate to login screen or home screen

        Get.offAllNamed('/userLogin');
        successSnackbar(
          'Success',
          'Successfully logged out',
        );
      } else {
        print('Failed to logout: ${response.statusCode}');
        errorSnackbar(
          'Error',
          'Failed to logout. Please try again.',
        );
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> refreshToken() async {
    if (_refreshToken == null) {
      errorSnackbar(
        'Error',
        'Refresh token is not available',
      );
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
        print('Access token refreshed successfully');
      } else if (response.statusCode == 401) {
        // Handle token blacklisting
        errorSnackbar(
          'Error',
          'Session expired. Please log in again.',
        );
        // Redirect to login screen
        Get.offAllNamed('/userLogin');
      } else {
        print('Failed to refresh token: ${response.body}');
        errorSnackbar(
          'Error',
          'Unexpected error occurred',
        );
      }
    } catch (e) {
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  // Fetch user profile function
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    if (accessToken == null) {
      errorSnackbar(
        'Error',
        'An unexpected error occurred',
      );
      print("Access token is not available");
      return null;
    }

    try {
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
      } else if (response.statusCode == 401) {
        // Handle token refresh if the response indicates the token is expired
        await refreshToken();
        // Retry fetching user profile
        return await fetchUserProfile();
      } else {
        errorSnackbar(
          'Error',
          'Failed to load user profile: ${response.statusCode} - ${response.body}',
        );
        print(
            'Failed response: ${response.body}'); // Log the response body for debugging
        return null;
      }
    } catch (e) {
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
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
      errorSnackbar(
        'Error',
        'User ID is not set.',
      );
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
        successSnackbar(
          'Success',
          'Phone number added successfully',
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
        errorSnackbar(
          'Error',
          errorMessage,
        );
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> addEmail(String email) async {
    if (user_id == null) {
      errorSnackbar(
        'Error',
        'User ID is not set.',
      );
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
        successSnackbar(
          'Success',
          'OTP sent to your email',
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
        errorSnackbar(
          'Error',
          errorMessage,
        );
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> resendOtp() async {
    if (user_id == null) {
      errorSnackbar(
        'Error',
        'User ID is not set.',
      );
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
        successSnackbar(
          'Success',
          'OTP resend to your email',
        );
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to resend OTP. Please try again.';
        }
        errorSnackbar(
          'Error',
          errorMessage,
        );
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
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
        Get.offAllNamed("/userphone");
        successSnackbar(
          'Success',
          'Email verified successfully',
        );
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(errorResponse);
        } else {
          errorMessage = 'Failed to verify OTP. Please try again.';
        }
        errorSnackbar(
          'Error',
          errorMessage,
        );
        print("${response.body}");
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred: $e',
      );
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
          Uri.parse('$baseUrl/accounts/customer/login/'),
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
          await storeTokens(accessToken, refreshToken);

          Get.offAllNamed('/phoneverify');
          successSnackbar(
            'Success',
            'Registration successful',
          ); // Change '/homepage' to the desired route
        } else {
          // Handle login failure
          errorSnackbar(
            'Error',
            'Login after registration failed.',
          );
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
        errorSnackbar(
          'Error',
          errorMessage,
        );
        print("${registerResponse.body}");
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
      );
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
        Uri.parse('$baseUrl/accounts/customer/login/'),
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
        final userType = loginData['user_type'];
        print('Type: $userType');
        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');
        setAccessToken(accessToken);
        setRefreshToken(refreshToken);
        await storeTokens(accessToken, refreshToken);
        await _secureStorage.write(key: 'user_type', value: userType);
        final dynamic userId = loginData['user_id'];
        if (userId is int) {
          user_id = userId.toString(); // Convert integer to string if necessary
        } else if (userId is String) {
          user_id = userId;
        } else {
          throw Exception('Unexpected user_id type');
        }
        Get.offAllNamed("/homescreen");
        successSnackbar(
          'Success',
          'Welcome back.',
        );
        // isLoggedIn.value = true;
        // await Future.delayed(Duration(seconds: 4));
        // Navigate to home screen or desired page
      } else {
        String errorMessage;
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          errorMessage = formatErrorMessage(
              errorResponse); // Concatenate all error messages
        } else {
          errorMessage = 'Login failed. Please try again.';
        }

        errorSnackbar(
          'Error',
          errorMessage,
        );
        print("${response.body}");
      }
    } catch (e) {
      Get.back();
      errorSnackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
      );
      print("$e");
    }
  }

  Future<bool> isLoggedIn() async {
    // print('accessToken: $accessToken');
    // Retrieve stored tokens
    accessToken = await _secureStorage.read(key: 'accessToken');
    _refreshToken = await _secureStorage.read(key: 'refreshToken');
    // final userType = await _secureStorage.read(key: 'user_type');

    // Check if access token is available
    if (accessToken == null) {
      print('No access token found. User is not logged in.');
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/profile/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Token is valid, now check user_type from secure storage
        final String? userType = await _secureStorage.read(key: 'user_type');

        // Check if user_type is "customer"
        if (userType == 'customer') {
          print('User is logged in as a customer.');
          successSnackbar(
            'Welcome back',
            '',
          );
          return true; // User is logged in and is a customer
        } else {
          print(
              'User is logged in but is not a customer. User type: $userType');
          return false; // User is logged in but not a customer
        }
      }
      // return true;
      else if (response.statusCode == 401) {
        // Token is expired or invalid

        print('Token expired or invalid. User is not logged in.');
        return false;
      } else {
        // Other error responses
        print('Failed to check login status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<void> sendUserLocation(double latitude, double longitude) async {
    Get.dialog(
      Center(child: CircularProgressIndicator(color: tPrimaryColor)),
      barrierDismissible: false,
    );

    try {
      // Make a POST request to send the location
      final response = await http.post(
        Uri.parse("$baseUrl/api/save-location/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );
      Get.back();
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Location successfully sent to server.');
        // Get.back();
        successSnackbar('Success', 'Location updated successfully.');
        Get.offNamed("/jobdetail");
      } else {
        // Get.back();
        print('Response body: ${response.body}');
        errorSnackbar('Error', 'Failed to set destination.');
      }
    } catch (e) {
      Get.back();
      print('Error sending location: $e');
      errorSnackbar('Error', 'Something went wrong.');
    }
  }
}
