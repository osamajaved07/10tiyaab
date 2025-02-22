// ignore_for_file: unused_element
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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

  Future<String> _getSkill() async {
    final skill = await storage.read(key: 'skill');
    return skill ?? 'Unknown Skill'; // Default to 'Unknown Skill' if not found
  }

  // Fetch both username and skill together
  Future<Map<String, String>> _getUserInfo() async {
    final username = await _getUsername();
    final skill = await _getSkill();
    return {'username': username, 'skill': skill};
  }

  void _showConfirmationDialog(BuildContext context) {
    QuickAlert.show(
        // backgroundColor: Colors.grey,
        context: context,
        type: QuickAlertType.warning,
        title: "Are you sure you want to start earning?",
        // text: 'Are you sure you want to start earning?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        showCancelBtn: true,
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () {
          Get.offNamed(
            '/spmap',
          );
          // Navigator.of(context).pop();
        },
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
        customAsset: 'assets/lottie/money.gif',
        width: MediaQuery.of(context).size.width * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final containerWidth =
            constraints.maxWidth * 0.35; // Adjust for padding
        final containerHeight =
            constraints.maxHeight * 0.12; // Adjust height to maintain aspect

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
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    height: screenHeight / 1,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: tlightPrimaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 15,
                          // vertical: screenHeight * 0.03
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FutureBuilder<Map<String, String>>(
                              future: _getUserInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: tPrimaryColor,
                                    backgroundColor: Colors.blueGrey,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Text('Error loading info');
                                } else {
                                  final username =
                                      snapshot.data?['username'] ?? 'User';

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
                            skillShow(screenHeight, screenWidth),

                            SizedBox(height: screenHeight * 0.05),
                            startEarningButton(
                                context, screenHeight, screenWidth),
                            SizedBox(height: screenHeight * 0.06),

                            //-----------first row of containers

                            firstRow(
                                containerWidth, containerHeight, screenWidth),

                            //-----------second row of containers

                            SizedBox(height: screenHeight * 0.05),

                            secondRow(
                                containerWidth, containerHeight, screenWidth),

                            //-----------third row of containers

                            SizedBox(height: screenHeight * 0.05),

                            thirdRow(
                                containerWidth, containerHeight, screenWidth),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: screenHeight / 12,
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
                                      Get.toNamed("/chatscreen");
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
      bottomNavigationBar: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  Row thirdRow(
      double containerWidth, double containerHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "36",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/coin.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Coins',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.119,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "0",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/wallet.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row secondRow(
      double containerWidth, double containerHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "8.0",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/verified.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Jobs completed',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.119,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2.0",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/pending.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Pending jobs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row firstRow(
      double containerWidth, double containerHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rs 100",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/earning.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Total earning',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tPrimaryColor,
                const Color.fromARGB(255, 3, 141, 141).withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 121, 121, 121)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset for the shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "5.0",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/images/rating.png",
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  )
                ],
              ),
              SizedBox(
                height: containerHeight * 0.17,
              ),
              Text(
                'Ratings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Center startEarningButton(
      BuildContext context, double screenHeight, double screenWidth) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showConfirmationDialog(context);
        },
        child: Material(
          color: Colors.transparent,
          elevation: 4,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black54),
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
    );
  }

  Material skillShow(double screenHeight, double screenWidth) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(1),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
        decoration: BoxDecoration(
            // boxShadow: [
            // BoxShadow(
            //   color: const Color.fromARGB(255, 121, 121, 121)
            //       .withOpacity(0.5), // Shadow color with opacity
            //   spreadRadius: 5, // Spread radius
            //   blurRadius: 7, // Blur radius
            //   offset: Offset(0, 3), // Offset for the shadow (x, y)
            // ),
            // ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Provider type:",
              style: TextStyle(
                  fontSize: screenHeight * 0.024,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
            ),
            Container(
              height: screenHeight * 0.03, // Adjust height as needed
              width: 2, // Width of the divider line
              color: Colors.grey[400], // Line color
            ),
            FutureBuilder<String>(
                future: _getSkill(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: tPrimaryColor,
                      backgroundColor: Colors.blueGrey,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading skill');
                  } else {
                    final skill = snapshot.data ?? 'Unknown Skill';
                    return Text(
                      skill,
                      style: TextStyle(
                          fontSize: screenHeight * 0.027,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800]),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final int initialIndex;

  BottomBar({required this.initialIndex});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
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
              '/sphome',
            );

            break;
          case 1:
            Get.toNamed(
              '/editSpProfile',
            );
            break;
          case 2:
            Get.toNamed(
              '/spactivity',
            );
            break;
          case 3:
            Get.toNamed(
              '/spcontact',
            );
            break;
        }
      },
    );
  }
}
