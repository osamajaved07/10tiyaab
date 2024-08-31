// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomBtn({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tPrimaryColor,
              shape: const StadiumBorder(),
              elevation: 0,
              // backgroundColor: Theme.of(context).buttonColor,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
              // minimumSize: Size(mq.width * .4, 50)
              ),
          onPressed: onTap,
          child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ttextColor),)),
    );
  }
}