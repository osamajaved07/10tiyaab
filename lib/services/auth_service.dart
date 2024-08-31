import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_urls.dart';

class AuthService {
  // Signup Function
  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final url = Uri.parse(ApiUrls.signup);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the response contains a token
        String token = data['token'];
        // Save the token using SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return {'success': true, 'data': data};
      } else {
        // Handle error response
        return {'success': false, 'message': data['error'] ?? 'Signup failed'};
      }
    } catch (e) {
      // Handle exception
      return {'success': false, 'message': e.toString()};
    }
  }

  // Signin Function
  Future<Map<String, dynamic>> signin(String email, String password) async {
    final url = Uri.parse(ApiUrls.signin);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Assuming the response contains a token
        String token = data['token'];
        // Save the token using SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return {'success': true, 'data': data};
      } else {
        // Handle error response
        return {'success': false, 'message': data['error'] ?? 'Signin failed'};
      }
    } catch (e) {
      // Handle exception
      return {'success': false, 'message': e.toString()};
    }
  }
}
