class CustomerSignup {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;

  CustomerSignup({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory CustomerSignup.fromJson(Map<String, dynamic> json) {
    return CustomerSignup(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirm_password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
