import 'package:flutter/material.dart';

const tPrimaryColor = Color(0xFF04BEBE);
const tlightPrimaryColor = Color.fromARGB(255, 229, 229, 229);
const tSecondaryColor = Color.fromARGB(255, 241, 241, 241);
const ttextColor = Color.fromARGB(255, 0, 0, 0);
const tsecondarytextColor = Color(0xFFFFFFFF);
const tContentColorLightTheme = Color(0xFF1D1D35);
const tContentColorDarkTheme = Color(0xFFF5FCF9);
const tWarninngColor = Color(0xFFF3BB1C);
const tErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

// font size for text
double tverysmallfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.037;
}

double tsmallfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.04;
} // Set a constant value

double tmidfontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.047;
}

double tlargefontsize(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.06;
}
