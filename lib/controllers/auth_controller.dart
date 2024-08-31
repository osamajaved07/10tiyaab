import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observables
  var isLoading = false.obs;
  var user = Rxn<User>();
  var errorMessage = ''.obs;

  // Signup Function
  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _authService.signup(name, email, password);

    if (response['success']) {
      // Parse user data if needed
      user.value = User.fromJson(response['data']);
      Get.snackbar('Success', 'Registration successful!',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed("/phoneverify");
    } else {
      errorMessage.value = response['message'];
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }

  // Signin Function
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _authService.signin(email, password);

    if (response['success']) {
      // Parse user data if needed
      user.value = User.fromJson(response['data']);
      Get.snackbar('Success', 'Login successful!',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed("/home"); // Navigate to home or dashboard
    } else {
      errorMessage.value = response['message'];
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }
}
