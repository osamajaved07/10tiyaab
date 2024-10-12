// // lib/services/api_service.dart
// // ignore_for_file: avoid_print

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<bool> registerUser(String username, String firstName, String lastName, String password, String confirmPassword) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/accounts/customer/signup/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'username': username,
//         'first_name': firstName,
//         'last_name': lastName,
//         'password': password,
//         'confirm_password': confirmPassword,
//       }),
//     );

//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       print('Error: ${response.body}'); // Log detailed error
//       return false;
//     }
//   }
// }
