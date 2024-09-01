class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      username: json['username'],
      password: json['password'],
    );
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String userType;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.userType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh'],
      userId: json['user_id'],
      userType: json['user_type'],
    );
  }
}
