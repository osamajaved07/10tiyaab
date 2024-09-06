// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fyp_1/models/onboard.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:fyp_1/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

 Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingCompleted', true);
  }
  
  @override
  Widget build(BuildContext context) {
    final c = PageController();

    final list = [
      Onboard(
        title: 'Best Solution for Every House Problems',
        subtitle: {
          'We work to ensure people comfort at their home and to provide the best and the fastest help at fair prices.':
              false,
        },
        lottie: 'OB1',
      ),
      Onboard(
        title: 'Find Handyman',
        lottie: 'OB2',
        subtitle: {
          'Choose your Tasker by reviews, skills, and price': true,
          'Find handyman close to you': true,
          'Chat, pay and review all through one platform': true,
        },
      ),
      Onboard(
        title: 'Our Services',
        subtitle: {
          'Plumbing Services': true,
          'Renovation Services': true,
          'Carpentry Services': true,
          'Roofing Services': true,
          'Electrical Services': true,
          '       and much more...': false,
        },
        lottie: 'OB3',
      ),
      Onboard(
        title: 'Make Your Own Handyman Account',
        subtitle: {
          'Grow Your Business': true,
          'Expand Your Network': true,
          'Become a Market Leader': true,
        },
        lottie: 'OB4',
      ),
    ];

    return Scaffold(
      backgroundColor: tSecondaryColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return PageView.builder(
          controller: c,
          itemCount: list.length,
          itemBuilder: (ctx, ind) {
            final isLast = ind == list.length - 1;
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/onboard/${list[ind].lottie}.png',
                    height: screenHeight * .6,
                    width: screenWidth * .9,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        list[ind].title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .015),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Column(
                      children: list[ind].subtitle.entries.map((entry) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry.value)
                              Icon(
                                Icons.check,
                                size: 18,
                                color: tPrimaryColor,
                              ),
                            if (entry.value) SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Spacer(),
                  Wrap(
                    spacing: 10,
                    children: List.generate(
                      list.length,
                      (i) => Container(
                        width: i == ind ? 15 : 10,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == ind ? tPrimaryColor : Colors.grey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isLast) // Only show this on the last page
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 12,
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 24,
                          ),
                        ),
                        onPressed: () async {
                          await _completeOnboarding();
                          Get.off(() => const UserSelection());
                        },
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: ttextColor,
                          ),
                        ),
                      ),
                    ),
                  if (!isLast) // Show Next button only if not on the last page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                          ),
                          onPressed: () async {
                            await _completeOnboarding();
                            Get.off(() => const UserSelection());
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: ttextColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 12,
                            padding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 24,
                            ),
                          ),
                          onPressed: () {
                            c.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.ease,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: ttextColor,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: ttextColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const Spacer(flex: 2),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
