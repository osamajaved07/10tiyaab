class EmailVerification {
  final String email;
  final String otp;

  EmailVerification({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  factory EmailVerification.fromJson(Map<String, dynamic> json) {
    return EmailVerification(
      email: json['email'],
      otp: json['otp'],
    );
  }
}
