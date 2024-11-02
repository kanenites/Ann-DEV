import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/user_type.dart';

class ReceiverDashboard extends StatefulWidget {
  const ReceiverDashboard({Key? key}) : super(key: key);

  @override
  _ReceiverDashboardState createState() => _ReceiverDashboardState();
}

class _ReceiverDashboardState extends State<ReceiverDashboard> {
  late List<ContributorData> _contributors = [];

  @override
  void initState() {
    super.initState();
    _loadContributors();
  }

  Future<void> _loadContributors() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('contributors').get();
    final contributorsData = snapshot.docs
        .map((doc) => ContributorData.fromSnapshot(doc))
        .toList();
    setState(() {
      _contributors = contributorsData;
    });
  }

  void _bookWaste(ContributorData contributor) async {
    try {
      // Debugging: Log current user details
      final currentUser = FirebaseAuth.instance.currentUser;
      print('Current User: ${currentUser?.email}');
      
      // Ensure that the user is logged in and has a valid email
      if (currentUser == null || currentUser.email == null || currentUser.email!.isEmpty) {
        throw Exception('Receiver email is missing or user is not authenticated');
      }

      // Add booking to Firestore
      await FirebaseFirestore.instance.collection('bookings').add({
        'email': contributor.email,
        'solidFood': contributor.solidFood ?? 0.0,
        'liquidFood': contributor.liquidFood ?? 0.0,
        'foodDescription': contributor.foodDescription ?? 'No description available',
        'receiverEmail': currentUser.email, // Ensure receiver email is valid
        'timestamp': FieldValue.serverTimestamp(),
        'address': contributor.address
      });

      // Update the contributor's document to mark it as booked
      await FirebaseFirestore.instance
          .collection('contributors')
          .doc(contributor.docId)
          .update({'booked': true});

      setState(() {
        contributor.booked = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food booked successfully!')),
      );
    } catch (error) {
      print('Error booking food: $error'); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book food: $error')),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserTypePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Redirect to the login screen if the user is not authenticated
      return Scaffold(
        body: Center(
          child: Text('User is not authenticated. Redirecting to login...'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('images/images2.jpg'), // Background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: _contributors.length,
            itemBuilder: (context, index) {
              return ContributorCard(
                contributor: _contributors[index],
                onBook: _contributors[index].booked
                    ? null
                    : () => _bookWaste(_contributors[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ContributorCard extends StatelessWidget {
  final ContributorData contributor;
  final VoidCallback? onBook;

  const ContributorCard({required this.contributor, this.onBook, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withOpacity(0.4), // Set background color to white with opacity
      elevation: 0, // Remove elevation to make it flat
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners if needed
      ),
      child: ListTile(
        title: Text(
          contributor.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${contributor.email}', style: const TextStyle(color: Colors.white)),
            Text('Solid Food: ${contributor.solidFood?.toStringAsFixed(2) ?? 0.0} kg',
                style: const TextStyle(color: Colors.white)),
            Text('Liquid Food: ${contributor.liquidFood?.toStringAsFixed(2) ?? 0.0} liters',
                style: const TextStyle(color: Colors.white)),
            Text('Description: ${contributor.foodDescription}', style: const TextStyle(color: Colors.white)),
            Text('Address: ${contributor.address}', style: const TextStyle(color: Colors.white)), // Add food description
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onBook,
          child: Text(contributor.booked ? 'Already Booked' : 'Book'),
          style: ElevatedButton.styleFrom(
            backgroundColor: contributor.booked ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}

class ContributorData {
  final String name;
  final String email;
  final double? solidFood;
  final double? liquidFood;
  bool booked; // Add a booked flag
  final String docId; // Store document ID for easy updates
  final String foodDescription;
  final String address; // Add a food description field

  ContributorData({
    required this.name,
    required this.email,
    this.solidFood,
    this.liquidFood,
    required this.booked,
    required this.docId,
    required this.foodDescription,
    required this.address // Add food description to constructor
  });

  factory ContributorData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ContributorData(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      solidFood: double.tryParse(data['solidFood']?.toString() ?? '0.0'),
      liquidFood: double.tryParse(data['liquidFood']?.toString() ?? '0.0'),
      booked: data['booked'] ?? false, // Fetch booked status from Firestore
      docId: snapshot.id, // Store document ID
      foodDescription: data['foodDescription'] ?? 'No description available',
      address:data['address'] ?? '' // Fetch food description
    );
  }
}
