// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_final_fields, unused_element
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/user_auth_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthController _authController = Get.find<AuthController>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  String? _profileImageUrl;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true; // Loading indicator
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authController.fetchUserProfile();
      if (userData != null) {
        setState(() {
          _userNameController.text = userData['username'] ?? '';
          _firstNameController.text = userData['first_name'] ?? '';
          _lastNameController.text = userData['last_name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneNumberController.text = userData['phone_no'] ?? '';
          _profileImageUrl = userData['profile_pic'] ?? '';
          _isLoading = false; // Stop loading when data is fetched
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      }); // Log the error
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // You might want to show an error message to the user here
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: tlightPrimaryColor,
          elevation: 8,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _authController.logout();
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() async {
    String profilePicPath = _pickedImage?.path ?? '';
    await _authController.updateUserInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      profilePicPath: profilePicPath.isNotEmpty ? profilePicPath : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: Icon(
              Icons.logout_outlined,
              color: tPrimaryColor,
              size: 32,
            ),
          )
        ],
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: tSecondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color:
                      tPrimaryColor)) // Show loader while data is being fetched
          : LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),

                        // Profile Picture Section
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.18,
                              backgroundImage: _pickedImage != null
                                  ? FileImage(File(
                                      _pickedImage!.path)) // Show picked image
                                  : (_profileImageUrl != null &&
                                              _profileImageUrl!.isNotEmpty
                                          ? NetworkImage(
                                              _profileImageUrl!) // Show server image
                                          : AssetImage(
                                              'assets/images/default_profile.png')) // Show default image
                                      as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                  ),
                                  child: Icon(Icons.camera_alt,
                                      size: screenWidth * 0.05),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // User Name
                        Text(
                          _userNameController.text.isNotEmpty
                              ? _userNameController.text
                              : 'Loading...', // Fallback text if username is not yet available
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Name TextField
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0), // Adds spacing to the right
                                child: _firstNameField(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0), // Adds spacing to the left
                                child: _lastNameField(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Email TextField
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: 'Email',
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          enabled: false, // Email is not editable
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.15,
                              height: screenHeight * 0.07,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  'assets/images/flag.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: TextField(
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android),
                                  labelText: 'Phone#',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              _updateProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF04BEBE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: ttextColor,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBarWidget(
        initialIndex: 1,
      ),
    );
  }

  TextFormField _firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your first name';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Firstname',
        labelText: 'Firstname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField _lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Enter your last name';
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        hintText: 'Lastname',
        labelText: 'Lastname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}
