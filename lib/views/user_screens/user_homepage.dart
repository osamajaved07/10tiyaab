// ignore_for_file: prefer_const_constructors, unnecessary_import, sort_child_properties_last, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/models/service_provider_list.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final UserAuthController authController = Get.find<UserAuthController>();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _serviceProviders = [
    'Electrician',
    'Carpenter',
    'Painter',
    'Plumber',
    'Welder',
    'Mechanic'
  ]; // Example list of service providers
  List<String> _filteredProviders = [];
  bool _isWhereToEnabled = false;
  bool _showSuggestions = false;
  String? selectedProvider;

  @override
  void initState() {
    super.initState();
    _filteredProviders = [];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showSuggestions = query.isNotEmpty;
      _filteredProviders = _serviceProviders
          .where((provider) =>
              provider.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredProviders.clear();
      _showSuggestions = false;
      _isWhereToEnabled = false;
      selectedProvider = null;
      FocusScope.of(context).unfocus(); // Closes the keyboard
    });
  }

  void _selectSuggestion(String suggestion) async {
    await _storage.write(key: 'selectedProvider', value: suggestion);
    setState(() {
      _searchController.text = suggestion;
      _filteredProviders.clear();
      _showSuggestions = false;
      _isWhereToEnabled = true;
      selectedProvider = suggestion;
      FocusScope.of(context).unfocus(); // Closes the keyboard
      print('Selected Service Provider: $suggestion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: tSecondaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: tSecondaryColor,
          elevation: 0,

          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed("/chatscreen");
                // Define your chat icon action here
                print('Chat icon pressed');
              },
              icon: Icon(
                Icons.chat_outlined,
                color: tPrimaryColor,
                size: 30,
              ),
            ),
            SizedBox(width: 16), // Add space between chat icon and edge
          ],
          title: Text(
            '10tiyaab',
            style: TextStyle(
              shadows: [
                Shadow(
                  offset: Offset(3.0, 3.0), // Shadow position
                  blurRadius: 5.0,
                  color: const Color.fromARGB(255, 180, 181, 181)
                      .withOpacity(0.5), // Shadow color
                ),
              ],
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
          // centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: Row(
                      //this contain vertical line and search box
                      children: [
                        Column(
                          //this contain vertical line and shapes
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey, // Circle color
                              ),
                            ),
                            Container(
                              width: 2, // Line thickness
                              height: screenHeight *
                                  0.08, // Adjust height as needed
                              color: Colors.grey, // Line color
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.black, // Square color
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Expanded(
                          child: Column(
                            //this contain search boxes
                            children: [
                              Material(
                                color: Colors.white,
                                elevation: 4,
                                shadowColor: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
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
                                      SizedBox(width: screenWidth * 0.02),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextField(
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Search service provider',
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
                                              onChanged: _onSearchChanged,
                                            ),
                                            if (_showSuggestions &&
                                                _filteredProviders.isNotEmpty)
                                              Container(
                                                height:
                                                    100, // Adjust the height as needed
                                                child: ListView.builder(
                                                  itemCount:
                                                      _filteredProviders.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                          _filteredProviders[
                                                              index]),
                                                      onTap: () =>
                                                          _selectSuggestion(
                                                              _filteredProviders[
                                                                  index]),
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: _clearSearch,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              GestureDetector(
                                onTap: _isWhereToEnabled
                                    ? () {
                                        Get.toNamed("/mapscreen", arguments: {
                                          'serviceProvider': selectedProvider
                                        });
                                      }
                                    : null, // Disable tap if not enabled
                                child: Material(
                                  color: Colors.white,
                                  elevation: 4,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    width: screenWidth,
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.016,
                                      horizontal: screenWidth * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isWhereToEnabled
                                          ? Colors.white
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            color: Colors.grey),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(
                                          "Where to?",
                                          style: TextStyle(
                                            color: Color(0xFF616161),
                                            fontSize: screenWidth * 0.045,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Second search bar
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: screenHeight * 0.02),
                        // First search bar with dropdown button

                        SizedBox(height: screenHeight * 0.04),
                        Material(
                          color: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121)
                                          .withOpacity(
                                              0.5), // Shadow color with opacity
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset: Offset(
                                      0, 3), // Offset for the shadow (x, y)
                                ),
                              ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Need a Handyman?\n\nBook Now →',
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
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Text(
                          'Suggestions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                _suggestionIcon(
                                  'assets/images/electrician.png',
                                  'Electrician',
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                _suggestionIcon(
                                    'assets/images/carpenter.png', 'Carpenter'),
                              ],
                            ),
                            Column(
                              children: [
                                _suggestionIcon(
                                  'assets/images/painter.png',
                                  'Painter',
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                _suggestionIcon(
                                    'assets/images/plumber.png', 'Plumber'),
                              ],
                            ),
                            Column(
                              children: [
                                _suggestionIcon(
                                  'assets/images/welder.png',
                                  'Welder',
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                _suggestionIcon(
                                    'assets/images/more.png', 'More'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          initialIndex: 0,
        ),
      ),
    );
  }

  Widget _suggestionIcon(String imagePath, String title) {
    return Container(
      width: MediaQuery.of(context).size.width / 4.5,
      height: MediaQuery.of(context).size.height / 8.5,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 190, 190, 190)
              .withOpacity(0.5), // Shadow color with opacity
          spreadRadius: 5, // Spread radius
          blurRadius: 7, // Blur radius
          offset: Offset(0, 3), // Offset for the shadow (x, y)
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40, // Adjust the size as needed
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
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
        Icon(Icons.person_2, size: 30, color: Colors.black),
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
            Get.toNamed(
              '/homescreen',
            );

            break;
          case 1:
            Get.toNamed(
              '/editprofile',
            );
            break;
          case 2:
            Get.toNamed(
              '/activity',
            );
            break;
          case 3:
            Get.toNamed(
              '/contactus',
            );
            break;
        }
      },
    );
  }
}
