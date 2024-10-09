// Future<void> submitJobDetails(
//   String jobDescription,
//   List<File> images,
//   String minPriceRange,
//   String maxPriceRange,
//   String userLocation,
//   String requiredSkill,
// ) async {
//   Get.dialog(
//     Center(
//       child: CircularProgressIndicator(
//         color: tPrimaryColor,
//       ),
//     ),
//     barrierDismissible: false,
//   );

//   if (accessToken == null) {
//     errorSnackbar(
//       'Error',
//       'An unexpected error occurred',
//     );
//     print("Access token is not available");
//     return null;
//   }

//   try {
//     // Create a multipart request for the images
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseUrl/api/service-request/'),
//     );

//     // Add headers for authentication
//     request.headers['Authorization'] = 'Bearer $accessToken';

//     // Add body fields
//     request.fields['job_description'] = jobDescription;
//     request.fields['min_price_range'] = minPriceRange;
//     request.fields['max_price_range'] = maxPriceRange;
//     request.fields['user_location'] = userLocation;
//     request.fields['required_skill'] = requiredSkill;

//     // Add images
//     if (images.isNotEmpty) {
//       for (var image in images) {
//         var fileStream = await http.MultipartFile.fromPath('images', image.path);
//         request.files.add(fileStream);
//       }
//     }

//     // Send the request
//     var response = await request.send();
//     Get.back(); // Dismiss loading

//     // Capture the response body
//     String responseBody = await response.stream.bytesToString();
//     print("Response status code: ${response.statusCode}");
//     print("Response body: $responseBody"); // Print response body

//     if (response.statusCode == 201) {
//       // Success
//       successSnackbar('Success', 'Details sent successfully.');
//     } else if (response.statusCode == 401) {
//       // Handle token refresh if the response indicates the token is expired
//       print('Access token expired. Refreshing token...');
//       await refreshToken();

//       // Retry submitting the job details after token refresh
//       var retryRequest = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/api/service-request/'),
//       );

//       retryRequest.headers['Authorization'] = 'Bearer $accessToken';

//       retryRequest.fields['job_description'] = jobDescription;
//       retryRequest.fields['min_price_range'] = minPriceRange;
//       retryRequest.fields['max_price_range'] = maxPriceRange;
//       retryRequest.fields['user_location'] = userLocation;
//       retryRequest.fields['required_skill'] = requiredSkill;

//       if (images.isNotEmpty) {
//         for (var image in images) {
//           var fileStream = await http.MultipartFile.fromPath('images', image.path);
//           retryRequest.files.add(fileStream);
//         }
//       }

//       var retryResponse = await retryRequest.send();
//       String retryResponseBody = await retryResponse.stream.bytesToString();
//       print("Retry response status code: ${retryResponse.statusCode}");
//       print("Retry response body: $retryResponseBody");

//       if (retryResponse.statusCode == 201) {
//         successSnackbar('Success', 'Details sent successfully after token refresh.');
//       } else {
//         print('Failed to send job details after token refresh: $retryResponseBody');
//         errorSnackbar('Error', 'Failed to submit job details after refreshing token.');
//       }
//     } else if (response.statusCode == 400) {
//       // Handle failure with specific error messages
//       String errorMessage = formatErrorMessage(jsonDecode(responseBody));
//       errorSnackbar('Error', errorMessage);
//     } else {
//       // General failure case
//       errorSnackbar('Error', 'Submission failed. Please try again.');
//     }
//   } catch (e) {
//     Get.back(); // Dismiss loading in case of error
//     errorSnackbar('Error', 'An unexpected error occurred. Please try again.');
//     print("Error: $e");
//   }
// }
