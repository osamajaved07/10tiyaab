// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        title: Text('Activity',
            style: TextStyle(color: Colors.black, fontSize: 24)),
        centerTitle: true,
        backgroundColor: tSecondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 28),
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: tPrimaryColor, // Replace with your custom primary color
                borderRadius: BorderRadius.circular(12.0),
              ),
              tabs: [
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ]),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return TabBarView(
          controller: _tabController,
          children: [
            _buildActivityList(context, "Completed"),
            _buildActivityList(context, "Cancelled"),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBarWidget(
        initialIndex: 2,
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, String tabType) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildActivityCard(
            name: 'M. Ali',
            profession: 'Electrician',
            time: 'Today at 09:20 am'),
        _buildActivityCard(
            name: 'Uzzam',
            profession: 'Plumber',
            time: 'Yesterday at 05:20 pm'),
        _buildActivityCard(
            name: 'Shoaib', profession: 'Carpenter', time: '2 Dec at 8:20 pm'),
      ],
    );
  }

  // Builds each card for the list
  Widget _buildActivityCard(
      {required String name,
      required String profession,
      required String time}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey.shade300, // Background color of the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(profession,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black)),
              ],
            ),
            Text(
              time,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
