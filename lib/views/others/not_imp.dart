// Future<bool> isLoggedIn() async {
//   // Retrieve stored tokens
//   accessToken = await _secureStorage.read(key: 'accessToken');
//   _refreshToken = await _secureStorage.read(key: 'refreshToken');

//   // Check if access token is available
//   if (accessToken == null) {
//     print('No access token found. User is not logged in.');
//     return false;
//   }

//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/accounts/profile/'),
//       headers: {'Authorization': 'Bearer $accessToken'},
//     );
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       // Token is valid, check user_type from secure storage
//       final String? userType = await _secureStorage.read(key: 'user_type');

//       // Check if user_type is "customer"
//       if (userType == 'customer') {
//         print('User is logged in as a customer.');
//         successSnackbar('Welcome back', '');
//         return true; // User is logged in and is a customer
//       } else {
//         print('User is logged in but is not a customer. User type: $userType');
//         return false; // User is logged in but not a customer
//       }
//     } else if (response.statusCode == 401) {
//       // Token expired, attempt to refresh the token
//       print('Access token expired. Refreshing token...');
//       await refreshToken(); // Directly call refreshToken

//       // Retry the request with the refreshed token
//       final retryResponse = await http.get(
//         Uri.parse('$baseUrl/accounts/profile/'),
//         headers: {'Authorization': 'Bearer $accessToken'},
//       );

//       if (retryResponse.statusCode == 200) {
//         // Token refresh was successful
//         final String? userType = await _secureStorage.read(key: 'user_type');
//         if (userType == 'customer') {
//           print('User is logged in as a customer after token refresh.');
//           successSnackbar('Welcome back', '');
//           return true;
//         } else {
//           print('User is not a customer after token refresh. User type: $userType');
//           return false;
//         }
//       } else {
//         // Refresh token failed, user is not logged in
//         print('Failed to retrieve profile after token refresh.');
//         return false;
//       }
//     } else {
//       // Other error responses
//       print('Failed to check login status: ${response.statusCode}');
//       return false;
//     }
//   } catch (e) {
//     print('Error checking login status: $e');
//     return false;
//   }
// }
