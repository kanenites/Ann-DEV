import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/admin/contributor_report.dart';
import 'package:waste_manage/receiver/receiver_report_page.dart';
import 'package:waste_manage/user_type.dart';
 // Import the ReceiverReportPage

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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

  void _markAsDelivered(ContributorData contributor) async {
    // Check if already marked as delivered
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('contributorEmail', isEqualTo: contributor.email)
        .where('status', isEqualTo: 'delivered')
        .get();

    if (bookingsSnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food already marked as delivered!')),
      );
      return;
    }

    // Update Firestore to mark the food as delivered
    FirebaseFirestore.instance
        .collection('bookings')
        .add({
          'contributorEmail': contributor.email,
          'solidFood': contributor.solidFood,
          'liquidFood': contributor.liquidFood,
          'foodDescription': contributor.foodDescription,
          'status': 'delivered',
          'timestamp': FieldValue.serverTimestamp(),
          'contributorAddress': contributor.address,
        })
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Food marked as delivered!')),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to mark as delivered: $error')),
          );
        });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/images4.jpeg'), // Background image
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
                onBook: null, // No booking needed in Admin Dashboard
                onMarkAsDelivered: () => _markAsDelivered(_contributors[index]),
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
  final VoidCallback? onMarkAsDelivered;

  const ContributorCard({required this.contributor, this.onBook, this.onMarkAsDelivered, Key? key}) : super(key: key);

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
            Text('Description: ${contributor.foodDescription}', style: const TextStyle(color: Colors.white)), // Add food description
            Text('Contributor Address: ${contributor.address}', style: const TextStyle(color: Colors.white)), // Add contributor address
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onMarkAsDelivered,
              child: Text('Mark as Delivered'),
            ),
            IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: () {
                // Navigate to ReceiverReportPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiverReportPage(
                      solidFood: contributor.solidFood ?? 0.0,
                      liquidFood: contributor.liquidFood ?? 0.0,
                      foodDescription: contributor.foodDescription, address: '', receiverName: '', receiverEmail: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ReceiverCard Class
class ReceiverCard extends StatelessWidget {
  final String receiverName;
  final String receiverEmail;
  final String receiverAddress;
  final double solidFood;
  final double liquidFood;
  final String foodDescription;

  const ReceiverCard({
    Key? key,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverAddress,
    required this.solidFood,
    required this.liquidFood,
    required this.foodDescription,
  }) : super(key: key);

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
          receiverName,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $receiverEmail', style: const TextStyle(color: Colors.white)),
            Text('Address: $receiverAddress', style: const TextStyle(color: Colors.white)),
            Text('Solid Food: ${solidFood.toStringAsFixed(2)} kg', style: const TextStyle(color: Colors.white)),
            Text('Liquid Food: ${liquidFood.toStringAsFixed(2)} liters', style: const TextStyle(color: Colors.white)),
            Text('Description: $foodDescription', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
