// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_final_fields, unused_element

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  // final SharedPreferences prefs;

  const EditProfilePage({super.key,});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name = "", email = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      });
  }

  Future<void> _pickImage() async {
  try {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  } catch (e) {
    print('Error picking image: $e');
  }
}

void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              onPressed: () {
                // Implement your logout logic here
                Navigator.of(context).pop(); // Close the dialog
                Get.offAllNamed('/login'); // Navigate to the login page
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            _showLogoutDialog(context);
          }, icon: Icon(Icons.logout_outlined))
        ],
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: tSecondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
         ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Profile Picture Section
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.18,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : AssetImage('assets/images/default.png')
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
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, size: screenWidth * 0.05),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // User Name
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Name TextField
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Email TextField
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // enabled: false, // Email is not editable
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Phone Number TextField with Flag
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/flag.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: '+92 3308963378',
                            disabledBorder: OutlineInputBorder(
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
                        // Handle update action
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
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: 1,),
    );
  }
}
