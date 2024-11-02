import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/functions/firebaseFunctions.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Before updateDisplayName: ${userCredential.user!.displayName}");
      await userCredential.user!.updateDisplayName(name);
      print("After updateDisplayName: ${userCredential.user!.displayName}");

// Store user data directly in the contributors collection
      await FirestoreServices.saveContributor(
          name, email, userCredential.user!.uid);

// Initialize solidWaste and liquidWaste fields with zero
      await FirebaseFirestore.instance
          .collection('contributors')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'solidWaste': 0,
        'liquidWaste': 0,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
    } catch (e) {
      // Handle other exceptions
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user account still exists
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('You are Logged in')));
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      }
    } on FirebaseAuthException catch (e) {
      // Handle exceptions (if needed)
    } catch (e) {
      // Handle other exceptions (if needed)
    }
  }

  static receiverLogin(String email, String password, BuildContext context) {}
}

class AdminAuthServices {
  static Future<UserCredential?> signupAdmin(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Before updateDisplayName: ${userCredential.user!.displayName}");
      await userCredential.user!.updateDisplayName(name);
      print("After updateDisplayName: ${userCredential.user!.displayName}");

      // Store user data directly in the admins collection (replace 'admins' with your collection name)
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        // Add other data if needed
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      print("Error creating admin account: $e");
      return null;
    } catch (e) {
      // Handle other exceptions
      print("Other error creating admin account: $e");
      return null;
    }
  }

  static Future<UserCredential?> signinAdmin(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user account still exists
      if (userCredential.user != null) {
        // You can perform additional checks here if needed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Admin logged in')));
        return userCredential;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid admin credentials')));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      print("Error signing in as admin: $e");
      return null;
    }
  }

  static Future<void> signoutAdmin(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Admin logged out')));
      // Redirect to login page or desired destination
    } catch (e) {
      // Handle exceptions
      print("Error signing out admin: $e");
    }
  }
}

class ReceiverAuthServices {
  static Future<UserCredential?> signupReceiver(
      String email, String password, String name, BuildContext context, String phone, BuildContext ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Before updateDisplayName: ${userCredential.user!.displayName}");
      await userCredential.user!.updateDisplayName(name);
      print("After updateDisplayName: ${userCredential.user!.displayName}");

      // Store user data directly in the admins collection (replace 'admins' with your collection name)
      await FirebaseFirestore.instance
          .collection('receiver')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        // Add other data if needed
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      print("Error creating receiver account: $e");
      return null;
    } catch (e) {
      // Handle other exceptions
      print("Other error creating receiver account: $e");
      return null;
    }
  }

  static Future<UserCredential?> signinReceiver(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user account still exists
      if (userCredential.user != null) {
        // You can perform additional checks here if needed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Receiver logged in')));
        return userCredential;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid admin credentials')));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      print("Error signing in as receiver: $e");
      return null;
    }
  }

  static Future<void> signoutReceiver(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Receiver logged out')));
      // Redirect to login page or desired destination
    } catch (e) {
      // Handle exceptions
      print("Error signing out receiver: $e");
    }
  }
}
