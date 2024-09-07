// lib/utils/custom_snackbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Utility method for showing styled snackbars
void successSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(193, 161, 217, 217),
    borderColor: Colors.green,
    borderWidth: 4,
    colorText: Colors.black,
    margin: const EdgeInsets.all(10),
    snackStyle: SnackStyle.FLOATING,
    boxShadows: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5,
        spreadRadius: 1,
      ),
    ],
  );
}

void errorSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(193, 161, 217, 217),
    borderColor: Colors.red,
    borderWidth: 4,
    colorText: Colors.black,
    margin: const EdgeInsets.all(10),
    snackStyle: SnackStyle.FLOATING,
    boxShadows: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5,
        spreadRadius: 1,
      ),
    ],
  );
}

// _isLoading
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF04BEBE),
//                           ),
//                         )
//                       :
