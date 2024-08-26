// ignore_for_file: prefer_const_constructors, unnecessary_import, sort_child_properties_last, non_constant_identifier_names, use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp_1/styles/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;

  HomeScreen({super.key, required this.prefs});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = "";

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
      key: _scaffoldKey, // Add this line
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
          icon: Icon(Icons.menu_outlined),
          color: tPrimaryColor,
        ),
        title: Text(
          "10tiyaab",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 24, color: tPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context, name),
      body: Center(
        child: Text(
          "Welcome to Homepage",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tPrimaryColor,
        child: Icon(Icons.add),
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
      ),
      bottomNavigationBar: Bottomnavigationbar(),
    );
  }

  CurvedNavigationBar Bottomnavigationbar() {
    return CurvedNavigationBar(
      index: 0,
      backgroundColor: tlightPrimaryColor, // Background color
      color: tSecondaryColor, // Button color
      buttonBackgroundColor: tPrimaryColor, // Active button color
      height: 50,
      items: <Widget>[
        Icon(
          Icons.messenger,
          size: 30,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.group),
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.person),
          iconSize: 30,
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context, String name) {
    return Drawer(
      elevation: 16,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 150, // Set the desired height here
            child: DrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: tPrimaryColor,
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle Home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _logout(context);
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
