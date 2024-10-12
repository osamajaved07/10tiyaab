// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_final_fields, unused_element
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_1/controllers/sp_auth_controller.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/utils/custom_dialog.dart';
import 'package:fyp_1/views/sp_screens/sp_home.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditSpProfilePage extends StatefulWidget {
  const EditSpProfilePage({
    super.key,
  });

  @override
  _EditSpProfilePageState createState() => _EditSpProfilePageState();
}

class _EditSpProfilePageState extends State<EditSpProfilePage> {
  final SpAuthController _authController = Get.find<SpAuthController>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _skillController = TextEditingController();
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
          _skillController.text = userData['skills'] ?? '';
          _phoneNumberController.text = userData['phone_no'] ?? '';
          _profileImageUrl = userData['profile_pic'] ?? '';
          _isLoading = false; // Stop loading when data is fetched
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      // setState(() {
      //   _isLoading = false; // Stop loading even if there's an error
      // }); // Log the error
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Show the loading indicator
    });

    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      errorSnackbar("Error", "Failed to pick image. Please try again.");
      // You might want to show an error message to the user here
    } finally {
      // Dismiss the loading dialog
      setState(() {
        _isLoading = false; // Hide the loading indicator
      });
    }
  }

  void _showConfirmationDialog(BuildContext context) {
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
                await _authController.splogout();
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
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: tSecondaryColor,
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: tPrimaryColor),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Loading...")
                  ],
                ),
              ) // Show loader while data is being fetched
            : LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 45.0, left: 20.0, right: 20.0),
                          height: screenHeight / 3.1,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              // color: const Color.fromARGB(84, 4, 190, 190),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width,
                                      105.0))),
                        ),
                        Positioned(
                            right: 0,
                            top: screenHeight * 0.045,
                            child: IconButton(
                                onPressed: () {
                                  _showConfirmationDialog(context);
                                },
                                icon: Icon(
                                  Icons.logout_outlined,
                                  color: ttextColor,
                                  size: 32,
                                ))),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.08),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height: screenHeight * 0.05),

                              // Profile Picture Section
                              picUpload(screenWidth),
                              SizedBox(height: screenHeight * 0.02),

                              // User Name
                              userName(screenWidth),
                              SizedBox(height: screenHeight * 0.04),

                              // Name TextField
                              nameField(),
                              SizedBox(height: screenHeight * 0.03),

                              // Email TextField
                              emailField(),
                              SizedBox(height: screenHeight * 0.03),
                              skillField(),
                              SizedBox(height: screenHeight * 0.03),
                              phoneNumberField(screenWidth, screenHeight),
                              SizedBox(height: screenHeight * 0.05),

                              // Update Button
                              updateButton(screenHeight, screenWidth),
                              SizedBox(height: screenHeight * 0.05),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: BottomBar(
          initialIndex: 1,
        ));
  }

  Row phoneNumberField(double screenWidth, double screenHeight) {
    return Row(
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
          child: phonenumberField(),
        ),
      ],
    );
  }

  Stack picUpload(double screenWidth) {
    return Stack(
      children: [
        CircleAvatar(
          radius: screenWidth * 0.18,
          backgroundImage: _pickedImage != null
              ? FileImage(File(_pickedImage!.path)) // Show picked image
              : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? NetworkImage(_profileImageUrl!) // Show server image
                      : AssetImage(
                          'assets/images/default_profile.png')) // Show default image
                  as ImageProvider,
        ),
        if (_isLoading) // Show loading indicator when _isLoading is true
          Center(
            child: CircularProgressIndicator(
              color: tPrimaryColor,
            ),
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
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Icon(Icons.camera_alt, size: screenWidth * 0.05),
            ),
          ),
        ),
      ],
    );
  }

  Row nameField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Adds spacing to the right
            child: Material(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(18),
                child: _firstNameField()),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0), // Adds spacing to the left
            child: Material(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(18),
                child: _lastNameField()),
          ),
        ),
      ],
    );
  }

  Text userName(double screenWidth) {
    return Text(
      _userNameController.text.isNotEmpty
          ? _userNameController.text
          : 'Loading...', // Fallback text if username is not yet available
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.05,
      ),
    );
  }

  Material updateButton(double screenHeight, double screenWidth) {
    return Material(
      elevation: 12,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
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
    );
  }

  Material emailField() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: TextField(
        controller: _emailController,
        style: TextStyle(color: ttextColor, fontWeight: FontWeight.w500),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined),
          labelText: 'Email',
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        enabled: false, // Email is not editable
      ),
    );
  }

  Material skillField() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: TextField(
        style: TextStyle(color: ttextColor, fontWeight: FontWeight.w500),
        controller: _skillController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.work_outline_sharp),
          labelText: 'Skill',
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        enabled: false, // Email is not editable
      ),
    );
  }

  Material phonenumberField() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(18),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allows only numeric input
          LengthLimitingTextInputFormatter(10), // Limits input to 10 digits
        ],
        controller: _phoneNumberController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          } else if (!RegExp(r'^[3]\d{9}$').hasMatch(value)) {
            return 'Enter your valid phone number';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_android),
          labelText: 'Phone#',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10), // Black border color
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  TextFormField _firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z]')), // Allow only alphabets
        LengthLimitingTextInputFormatter(8), // Limits input to 10 characters
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your first name';
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Firstname',
        labelText: 'Firstname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  TextFormField _lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z]')), // Allow only alphabets
        LengthLimitingTextInputFormatter(8), // Limits input to 10 characters
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your last name';
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Lastname',
        labelText: 'Lastname',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}
