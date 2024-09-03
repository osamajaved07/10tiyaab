// Future<void> _loadUserData() async {
//   try {
//     final userData = await _authController.fetchUserProfile();
//     if (userData != null) {
//       setState(() {
//         _firstNameController.text = userData['first_name'];
//         _lastNameController.text = userData['last_name'];
//         _emailController.text = userData['email'];
//         _phoneNumberController.text = userData['phone_number'];
//         _hasError = false;
//       });
//     } else {
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'User data not found.';
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _hasError = true;
//       _errorMessage = 'Failed to load user profile: $e';
//     });
//   }
// }
