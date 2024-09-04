// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fyp_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({
      'hasSeenSplashScreen': true, // Adjust based on what needs to be tested
      'isOnboardingCompleted': true, // Adjust based on your test scenario
    });
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets(
      'SplashScreen navigates to correct screen based on SharedPreferences',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    bool isLoggedIn = false;
    bool hasSeenSplash = true;

    await tester.pumpWidget(MyApp(
      isLoggedIn: isLoggedIn,
      hasSeenSplash: hasSeenSplash,
    ));
 
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

   
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

   
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
