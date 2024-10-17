import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/user_type.dart';

void main() {
  runApp(MaterialApp(
    home: ContributorDashboard(),
  ));
}

class ContributorDashboard extends StatefulWidget {
  const ContributorDashboard({Key? key});

  @override
  _ContributorDashboardState createState() => _ContributorDashboardState();
}

class _ContributorDashboardState extends State<ContributorDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  TextEditingController _solidFoodController = TextEditingController();
  TextEditingController _liquidFoodController = TextEditingController();
  TextEditingController _foodDescriptionController = TextEditingController(); // New Controller

  Stream<DocumentSnapshot>? _contributorDataStream;

  double _solidFood = 0; // Variable to hold solid waste data
  double _liquidFood = 0; // Variable to hold liquid waste data

  @override
  void initState() {
    super.initState();

    // Listen for changes in user authentication state
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });

      if (user != null) {
        _loadContributorData();
      }
    });
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      Navigator.popAndPushNamed(context, UserTypePage() as String);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _loadContributorData() async {
    _contributorDataStream = _firestore
        .collection('contributors')
        .doc(_user!.uid)
        .snapshots();

    _contributorDataStream!.listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _solidFood = double.parse(snapshot['solidFood'] ?? '0');
          _liquidFood = double.parse(snapshot['liquidFood'] ?? '0');
          _user!.updateDisplayName(snapshot['restaurantName'] ?? ''); 
        });
      }
    });
  }

  void _submitFood() async {
    final data = {
      'solidFood': _solidFoodController.text,
      'liquidFood': _liquidFoodController.text,
      'foodDescription': _foodDescriptionController.text, // Add Description Field
    };

    await _firestore.collection('contributors').doc(_user!.uid).set(
      data,
      SetOptions(merge: true),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Food data submitted successfully')),
    );

    // Clear the input fields
    _solidFoodController.clear();
    _liquidFoodController.clear();
    _foodDescriptionController.clear(); // Clear Description Field
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Contributor Dashboard')),
    body: Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/images3.jpg'), // Path to your image
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), // Optional: dark overlay for better contrast
                BlendMode.darken,
              ),
            ),
          ),
        ),
        // Main content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user?.displayName ?? ''}', // Use an empty string as a fallback
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                  ),
                ),
                Text(
                  _user?.email ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // White text for contrast
                  ),
                ),
                
                TextFormField(
                  controller: _solidFoodController,
                  decoration: InputDecoration(
                    labelText: 'Solid Food Input (in kg)',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8), // Slightly transparent
                  ),
                ),
                TextFormField(
                  controller: _liquidFoodController,
                  decoration: InputDecoration(
                    labelText: 'Liquid Food Input (in liters)',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8), // Slightly transparent
                  ),
                ),
                TextFormField(
                  controller: _foodDescriptionController, // New Description Field
                  decoration: InputDecoration(
                    labelText: 'Food Description',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8), // Slightly transparent
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitFood,
                  child: Text('Submit Food'),
                ),
                // Rest of your widgets
              ],
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _signOut,
      child: Icon(Icons.logout),
    ),
  );
}
}
