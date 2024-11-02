import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/contributor/contributor_dashboard.dart';
import 'package:waste_manage/user_type.dart';

import 'admin/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "add your api key",
        authDomain: "add your domain",
        projectId: "add yor project-id",
        storageBucket: "add bucket id",
        messagingSenderId: "add messaging id",
        appId: "add app id"
      ),
    );
    runApp(const MyApp());
  } catch (e) {
    print("Error during Firebase initialization: $e");
  }
}

Future<Map<String, dynamic>> getUserDataFromDatabase(String uid) async {
  try {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return {};
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              return FutureBuilder<Map<String, dynamic>>(
                future: getUserDataFromDatabase(user.uid),
                builder: (context, userDataSnapshot) {
                  if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userDataSnapshot.hasData) {
                    bool isAdmin = userDataSnapshot.data?['role'] == 'admin';
                    return isAdmin ? const AdminDashboard() : const ContributorDashboard();
                  } else {
                    return const UserTypePage();
                  }
                },
              );
            } else {
              return const UserTypePage();
            }
          } else {
            return const UserTypePage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
