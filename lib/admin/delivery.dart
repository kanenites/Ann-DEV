import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/admin/contributor_report.dart';
import 'package:waste_manage/user_type.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({Key? key}) : super(key: key);

  @override
  _DeliveryDashboardState createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  late List<ContributorData> _contributors = [];

  @override
  void initState() {
    super.initState();
    _loadContributors();
  }

  Future<void> _loadContributors() async {
    final snapshot = await FirebaseFirestore.instance.collection('contributors').get();
    final contributorsData = snapshot.docs
        .map((doc) => ContributorData.fromSnapshot(doc))
        .toList();
    
    setState(() {
      _contributors = contributorsData;
    });
  }

  void _markAsDelivered(ContributorData contributor) async {
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('email', isEqualTo: contributor.email)
        .where('status', isEqualTo: 'delivered')
        .get();

    if (bookingsSnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food already marked as delivered!')),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('bookings')
        .add({
          'email': contributor.email,
          'solidFood': contributor.solidFood,
          'liquidFood': contributor.liquidFood,
          'foodDescription': contributor.foodDescription,
          'status': 'delivered',
          'timestamp': FieldValue.serverTimestamp(),
          'address': contributor.address,
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
        title: const Text('Delivery Dashboard'),
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
                image: AssetImage('images/images5.jpg'),
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
  final VoidCallback? onMarkAsDelivered;

  const ContributorCard({
    required this.contributor,
    this.onMarkAsDelivered,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withOpacity(0.4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
            Text('Contributor Address: ${contributor.address}', style: const TextStyle(color: Colors.white)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onMarkAsDelivered,
          child: Text('Mark as Delivered'),
        ),
      ),
    );
  }
}
