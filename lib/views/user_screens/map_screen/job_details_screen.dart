// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_1/utils/colors.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: tPrimaryColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text("Job Detail",
            style: TextStyle(
                color: Colors.black, fontSize: tmidfontsize(context))),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Adds spacing to the right
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
                        padding: const EdgeInsets.only(
                            left: 8.0), // Adds spacing to the left
                        child: Material(
                            color: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(18),
                            child: _lastNameField()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
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
