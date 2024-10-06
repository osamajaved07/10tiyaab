// //  Future<void> submitJobDetails({
// //   required String maxPrice,
// //   required String jobDescription,
// //   String? minPrice,
// //   List<File>? images,
// // }) async {
// //   // Check if compulsory fields are provided
// //   if (maxPrice.isEmpty || jobDescription.isEmpty) {
// //     throw Exception("Max price and job description are required.");
// //   }

// //   // Create a multipart request
// //   var request = http.MultipartRequest('POST', Uri.parse('https://fyp-project-zosb.onrender.com/api/save-location/'));

// //   // Add fields to request
// //   request.fields['max_price'] = maxPrice;
// //   request.fields['description'] = jobDescription;

// //   if (minPrice != null && minPrice.isNotEmpty) {
// //     request.fields['min_price'] = minPrice;
// //   }

// //   // Add images to request if available
// //   if (images != null) {
// //     for (var image in images) {
// //       var fileStream = await http.MultipartFile.fromPath('images[]', image.path);
// //       request.files.add(fileStream);
// //     }
// //   }

// //   // Send the request to the server
// //   var response = await request.send();

// //   if (response.statusCode == 200) {
// //     // Handle success
// //     print("Job details submitted successfully");
// //   } else {
// //     // Handle failure
// //     throw Exception("Failed to submit job details. Status code: ${response.statusCode}");
// //   }
// // }

//   Future<void> submitJobDetails(
//     String job_description,
//     String images,
//     String min_price_range,
//     String max_price_range,
//     String user_location,
//     String required_skill,
//     String accessToken,
//   ) async {
//     Get.dialog(
//       Center(
//           child: CircularProgressIndicator(
//         color: tPrimaryColor,
//       )),
//       barrierDismissible: false,
//     );

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/service-request/'),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           // 'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'job_description': job_description,
//           'images': images,
//           'min_price_range': min_price_range,
//           'max_price_range': max_price_range,
//           'user_location': user_location,
//           'required_skill': required_skill,
//         }),
//       );
//       Get.back();
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> loginData = jsonDecode(response.body);
//         successSnackbar(
//           'Success',
//           'Detail stored.',
//         );
//       } else {
//         String errorMessage;
//         if (response.statusCode == 400) {
//           final Map<String, dynamic> errorResponse = jsonDecode(response.body);
//           errorMessage = formatErrorMessage(
//               errorResponse); // Concatenate all error messages
//         } else {
//           errorMessage = 'Login failed. Please try again.';
//         }

//         errorSnackbar(
//           'Error',
//           errorMessage,
//         );
//         print("${response.body}");
//       }
//     } catch (e) {
//       Get.back();
//       errorSnackbar(
//         'Error',
//         'An unexpected error occurred. Please try again.',
//       );
//       print("$e");
//     }
//   }