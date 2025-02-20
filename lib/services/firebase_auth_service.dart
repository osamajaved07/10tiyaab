import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to register a new user
  Future<void> registerUser(String username, String password) async {
    try {
      // Generate a unique email for the user
      String email = '$username@example.com';

      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Store the username in Firestore
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
      });
      print("User registered successfully");
    } catch (e) {
      print("Error registering user: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to log in a user
  Future<void> loginUser(String username, String password) async {
    try {
      // Generate a unique email for the user
      String email = '$username@example.com';

      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String fetchedUsername = userData['username'];
        print("Logged in User: $fetchedUsername");

        print("User loggedIn successfully");
      } else {
        Get.snackbar(
          'Error',
          'User data not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error logging in user: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
