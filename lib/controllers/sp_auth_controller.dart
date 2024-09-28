// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/custom_dialog.dart';
import 'package:get/get.dart';

class SpAuthController extends GetxController {
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

// ----------------- format message function ------------------
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
        } else if (message.contains(
            'Only service provider are allowed to access this route.')) {
          formattedMessage.writeln('Invalid username or password');
        } else {
          formattedMessage.writeln(message);
        }
      } else {
        formattedMessage.writeln(value.toString());
      }
    });
    return formattedMessage.toString().trim();
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

  //--------- Service provider login function ----------------
  Future<void> splogin(String username, String password) async {
    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: tPrimaryColor,
      )),
      barrierDismissible: false,
    );
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/sp/login/'),
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
        final skill = loginData['skill'];
        final serviceProviderUsername = loginData['username'];
        print('Service Provider Name: $serviceProviderUsername');
        print('Service Provider Type: $skill');
        print('Type: $userType');
        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');
        setAccessToken(accessToken);
        setRefreshToken(refreshToken);
        await storeTokens(accessToken, refreshToken);
        await _secureStorage.write(key: 'skill', value: skill);
        await _secureStorage.write(
            key: 'username', value: serviceProviderUsername);
        await _secureStorage.write(key: 'user_type', value: userType);

        // user_id = loginData['user_id'].toString(); // Update user_id
        final dynamic userId = loginData['user_id'];
        if (userId is int) {
          user_id = userId.toString(); // Convert integer to string if necessary
        } else if (userId is String) {
          user_id = userId;
        } else {
          throw Exception('Unexpected user_id type');
        }
        Get.offAllNamed("/sphome");
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
      Get.snackbar('Error', 'An unexpected error occurred. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      print("$e");
    }
  }

  Future<bool> isspLoggedIn() async {
    print('accessToken: $accessToken');
    // Retrieve stored tokens
    accessToken = await _secureStorage.read(key: 'accessToken');
    _refreshToken = await _secureStorage.read(key: 'refreshToken');

    // Check if access token is available
    if (accessToken == null) {
      print('No access token found. User is not logged in.');
      return false;
    }

    try {
      // Always attempt to refresh the token to ensure it's up-to-date
      // await refreshToken();

      // Now check if the access token is valid
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/profile/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        // Token is valid and user is logged in
        print('User is logged in.');
        successSnackbar(
          'Welcome back',
          '',
        );
        return true;
      } else if (response.statusCode == 401) {
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

//----------Fetch profile--------------

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

//----------Send Feedback--------------

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

//----------Update Information--------------

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

//----------logout function--------------

  Future<void> splogout() async {
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

        Get.offAllNamed('/professionalLogin');
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
}
