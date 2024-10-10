// lib/utils/custom_snackbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// void showCustomDialog(String title, String message, bool isSuccess) {
//   Get.dialog(
//     AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Icon at the top
//           Icon(
//             isSuccess ? Icons.check_circle_outline : Icons.error_outline,
//             color: isSuccess ? Colors.green : Colors.red,
//             size: 50,
//           ),
//           const SizedBox(height: 20),
//           // Title text
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isSuccess ? Colors.green : Colors.red,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 10),
//           // Message text
//           Text(
//             message,
//             style: const TextStyle(fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     ),
//     barrierDismissible: true, // Disable dialog dismissal by tapping outside
//   );

//   // Automatically dismiss the dialog after 2 seconds
//   Future.delayed(const Duration(seconds: 4), () {
//     if (Get.isDialogOpen!) {
//       Get.back(); // Close the dialog
//     }
//   });
// }

void showCustomDialog(String title, String message, bool isSuccess) {
  QuickAlert.show(
    context: Get.context!,
    type: isSuccess ? QuickAlertType.success : QuickAlertType.error,
    title: title,
    autoCloseDuration: Duration(seconds: 4),
    text: message,
    confirmBtnText: 'OK',
    confirmBtnColor: isSuccess ? Colors.green : Colors.red,
    onConfirmBtnTap: () {
      Navigator.of(Get.context!).pop(); // Close the dialog
    },
  );
}

// Usage for success and error dialogs
void successSnackbar(String title, String message) {
  showCustomDialog(title, message, true);
}

void errorSnackbar(String title, String message) {
  showCustomDialog(title, message, false);
}
