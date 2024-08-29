// ignore_for_file: prefer_const_constructors, unnecessary_import, sort_child_properties_last, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fyp_1/model/service_provider_list.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const UserHomeScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = "";
  String? selectedServiceProvider;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    setState(() {
      name = widget.prefs.getString('name') ?? 'User';
    });
  }

  Future<void> _logout(BuildContext context) async {
    // Clear user data from SharedPreferences
    // await prefs.clear();

    // Show a snackbar confirming the logout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to the LoginScreen
    Get.offNamed("/userLogin");
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tSecondaryColor,
        elevation: 0,
        title: Text(
          '10tiyaab',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  // First search bar with dropdown button
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.001,
                      horizontal: screenWidth * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: screenWidth * 0.08),
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedServiceProvider,
                            hint: Text(
                              'Select Service Provider',
                              style: TextStyle(
                                color: Color(0xFF616161),
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            items: ServiceProviderList.serviceProviders.map((String provider) {
                              return DropdownMenuItem<String>(
                                value: provider,
                                child: Text(provider),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedServiceProvider = newValue;
                              });
                            },
                            underline: SizedBox(),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey),
                          ),
                        ),
                        
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.015),

// Second search bar
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.001,
                      horizontal: screenWidth * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Where to?',
                              hintStyle: TextStyle(
                                color: Color(0xFF616161),
                                fontSize: screenWidth * 0.045,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF04BEBE), Color(0xFF025858)],
                        stops: [0.47, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Skillful Person\nBook Now →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            'assets/images/worker.png',
                            width: screenWidth * 0.3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Suggestions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _suggestionIcon(Icons.electric_bolt, 'Electrician'),
                      _suggestionIcon(Icons.handyman, 'Carpenter'),
                      _suggestionIcon(Icons.plumbing, 'Plumber'),
                      _suggestionIcon(Icons.calendar_today, 'Reserve'),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Around you',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: 0,),
    );
  }

  Widget _suggestionIcon(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 30, color: Colors.black54),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class BottomNavigationBarWidget extends StatefulWidget {
  final int initialIndex;

  BottomNavigationBarWidget({required this.initialIndex});

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set the initial index
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _currentIndex,
      backgroundColor: Colors.transparent,
      color: Colors.white,
      buttonBackgroundColor: tPrimaryColor,
      height: 60,
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.black),
        Icon(Icons.person_2_outlined, size: 30, color: Colors.black),
        Icon(Icons.local_activity, size: 30, color: Colors.black),
        Icon(Icons.phone, size: 30, color: Colors.black),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        // Navigate based on the tapped index
        switch (index) {
          case 0:
            Get.toNamed('/homescreen',);

            break;
          case 1:
             Get.toNamed('/editprofile',);
            break;
          case 2:
             Get.toNamed('/homescreen',);
            break;
          case 3:
             Get.toNamed('/homescreen',);
            break;
        }
      },
    );
  }
}
