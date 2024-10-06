// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, equal_keys_in_map, unnecessary_import, unused_import, unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:fyp_1/controllers/sp_auth_controller.dart';
import 'package:fyp_1/controllers/user_auth_controller.dart';
import 'package:fyp_1/views/user_screens/map_screen/job_details_screen.dart';
import 'package:fyp_1/views/user_screens/map_screen/map_screen.dart';
import 'package:fyp_1/views/others/onboarding_screen.dart';
import 'package:fyp_1/views/sp_screens/edit_sp_profile.dart';
import 'package:fyp_1/views/sp_screens/map_screens/map_screen.dart';
import 'package:fyp_1/views/sp_screens/sp_act_screen.dart';
import 'package:fyp_1/views/sp_screens/sp_contact.dart';
import 'package:fyp_1/views/sp_screens/sp_home.dart';
import 'package:fyp_1/views/user_screens/activity_screen.dart';
import 'package:fyp_1/views/user_screens/chat_screens/chat_home.dart';
import 'package:fyp_1/views/verifications/email_verify.dart';
import 'package:fyp_1/views/verifications/final.dart';
import 'package:fyp_1/views/verifications/phoneinput.dart';
import 'package:fyp_1/views/verifications/verify_final.dart';
import 'package:fyp_1/views/others/home.dart';
import 'package:fyp_1/views/sp_screens/sp_login.dart';
import 'package:fyp_1/views/sp_screens/sp_registration.dart';
import 'package:fyp_1/views/others/selection_screen.dart';
import 'package:fyp_1/views/others/splash_screen.dart';
import 'package:fyp_1/views/user_screens/contactus_screen.dart';
import 'package:fyp_1/views/user_screens/edit_profile_screen.dart';
import 'package:fyp_1/views/user_screens/user_homepage.dart';
import 'package:fyp_1/views/user_screens/user_login.dart';
import 'package:fyp_1/views/user_screens/user_registration.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/user_screens/chat_screens/chat_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserAuthController authController = Get.put(UserAuthController());
  final SpAuthController spAuthController = Get.put(SpAuthController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '10tiyaab',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoFlexTextTheme(),
        primaryColor: Colors.black,
        useMaterial3: false,
      ),
      home: SplashScreen(),
      // initialRoute: '/',
      getPages: [
//--------------------Customer screens------------------------------

        GetPage(name: '/onboarding_screen', page: () => OnboardingScreen()),
        GetPage(name: '/selection', page: () => UserSelection()),

        GetPage(
            name: '/userregister',
            page: () => UserRegister(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userLogin',
            page: () => UserLogin(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/phoneverify',
            page: () => EmailVerification(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/verify',
            page: () => MyVerify(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userphone',
            page: () => PhoneNumberInputPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/userregisterfinal',
            page: () => Final(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/homescreen',
            page: () => UserHomeScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/activity',
            page: () => ActivityScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/chatscreen',
            page: () => ChatHome(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/chatdetailscreen',
            page: () => ChatDetailScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/editprofile',
            page: () => EditProfilePage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/contactus',
            page: () => ContactUsScreen(),
            transition: Transition.fadeIn),

//--------------------User Map screens------------------------------
        GetPage(
            name: '/mapscreen',
            page: () => UserMapScreen(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/jobdetail',
            page: () => JobDetails(),
            transition: Transition.fadeIn),

//--------------------Service provider screens------------------------------

        GetPage(
            name: '/professionalregister',
            page: () => ServiceProviderRegistration(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/professionalLogin',
            page: () => ServiceProviderLogin(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/sphome',
            page: () => SpHomeScreen(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/editSpProfile',
            page: () => EditSpProfilePage(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/spactivity',
            page: () => SpActivityScreen(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/spcontact',
            page: () => SpContactUsScreen(),
            transition: Transition.fadeIn),

        GetPage(
            name: '/spmap',
            page: () => SpMapScreen(),
            transition: Transition.fadeIn),
      ],
    );
  }
}
