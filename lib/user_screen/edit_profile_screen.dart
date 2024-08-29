// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:fyp_1/user_screen/user_homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final SharedPreferences prefs;

  const EditProfilePage({super.key, required this.prefs});

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
      name = widget.prefs.getString('name') ?? 'User';
      _nameController.text = name;
      email = widget.prefs.getString('email') ?? '123@gmail.com';
      _emailController.text = email;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
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
                            : AssetImage('assets/images/fb.png')
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
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    enabled: false, // Email is not editable
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
                          decoration: InputDecoration(
                            labelText: '+92 3308963378',
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
                    height: screenHeight * 0.07,
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
