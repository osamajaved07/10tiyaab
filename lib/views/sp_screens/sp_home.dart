import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class SpHomeScreen extends StatefulWidget {
  const SpHomeScreen({super.key});

  @override
  State<SpHomeScreen> createState() => _SpHomeScreenState();
}

class _SpHomeScreenState extends State<SpHomeScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String> _getUsername() async {
    final username = await storage.read(key: 'username');
    return username ?? 'User'; // Default to 'User' if username is not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Container(
              height: screenHeight,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight / 2.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                          tPrimaryColor,
                          tPrimaryColor.withOpacity(0.4),
                        ])),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight / 6),
                    height: screenHeight / 1,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: tlightPrimaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight / 30,
                          ),
                          FutureBuilder<String>(
                            future: _getUsername(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error loading username');
                              } else {
                                final username = snapshot.data ?? 'User';
                                return Text(
                                  "Hello $username",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.029,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            "Welcome back!",
                            style: TextStyle(
                                fontSize: screenHeight * 0.022,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                          ),
                          SizedBox(
                            height: screenHeight * 0.06,
                          ),
                          Container(
                            // width: screenWidth * 0.5,
                            // height: screenHeight * 0,
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.05),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Provider type:",
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.027,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]),
                                ),
                                Text(
                                  "Plumber",
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.03,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Get.snackbar("Start earning", "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: screenWidth * 0.05),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black54),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  'Start earning →',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: screenHeight / 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: screenWidth / 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                  fontSize: screenHeight * 0.035,
                                  color: ttextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      print("Chat button pressed");
                                    },
                                    icon: Icon(Icons.chat_outlined)),
                                IconButton(
                                    onPressed: () {
                                      print("Notification button pressed");
                                    },
                                    icon: Icon(
                                        Icons.notifications_none_outlined)),
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              )),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        initialIndex: 0,
      ),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  BottomNavigationBar({required this.initialIndex});

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
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
      backgroundColor: tlightPrimaryColor,
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
              '/sphome',
            );

            break;
          case 1:
            Get.toNamed(
              '',
            );
            break;
          case 2:
            Get.toNamed(
              '',
            );
            break;
          case 3:
            Get.toNamed(
              '',
            );
            break;
        }
      },
    );
  }
}
