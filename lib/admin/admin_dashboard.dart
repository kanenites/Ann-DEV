import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_manage/admin/contributor_report.dart';
import 'package:waste_manage/user_type.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late List<ContributorData> _contributors = [];
  List<ContributorData> _filteredContributors = [];  // For search and filter
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContributors();
  }

  Future<void> _loadContributors() async {
    final snapshot = await FirebaseFirestore.instance.collection('contributors').get();
    final contributorsData = snapshot.docs.map((doc) => ContributorData.fromSnapshot(doc)).toList();
    setState(() {
      _contributors = contributorsData;
      _filteredContributors = contributorsData;  // Initialize filtered list
    });
  }

  void _filterContributors(String query) {
    setState(() {
      _filteredContributors = _contributors.where((contributor) {
        return contributor.name.toLowerCase().contains(query.toLowerCase()) ||
            contributor.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _markAsDelivered(ContributorData contributor) async {
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

    FirebaseFirestore.instance.collection('bookings').add({
      'contributorEmail': contributor.email,
      'solidFood': contributor.solidFood,
      'liquidFood': contributor.liquidFood,
      'foodDescription': contributor.foodDescription,
      'status': 'delivered',
      'timestamp': FieldValue.serverTimestamp(),
      'contributorAddress': contributor.address,
    }).then((_) {
      _sendNotification(contributor.email, 'Your food donation has been marked as delivered!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food marked as delivered!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as delivered: $error')),
      );
    });
  }

  void _sendNotification(String email, String message) {
    FirebaseFirestore.instance.collection('notifications').add({
      'email': email,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
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
                image: AssetImage('images/images4.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Contributors",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _filterContributors,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredContributors.length,
                  itemBuilder: (context, index) {
                    return ContributorCard(
                      contributor: _filteredContributors[index],
                      onMarkAsDelivered: () => _markAsDelivered(_filteredContributors[index]),
                    );
                  },
                ),
              ),
            ],
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
        title: Text(contributor.name, style: const TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${contributor.email}', style: const TextStyle(color: Colors.white)),
            Text('Solid Food: ${contributor.solidFood?.toStringAsFixed(2) ?? 0.0} kg', style: const TextStyle(color: Colors.white)),
            Text('Liquid Food: ${contributor.liquidFood?.toStringAsFixed(2) ?? 0.0} liters', style: const TextStyle(color: Colors.white)),
            Text('Description: ${contributor.foodDescription}', style: const TextStyle(color: Colors.white)),
            Text('Address: ${contributor.address}', style: const TextStyle(color: Colors.white)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContributorActivityLog(contributor: contributor),
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

class ContributorActivityLog extends StatelessWidget {
  final ContributorData contributor;

  const ContributorActivityLog({Key? key, required this.contributor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${contributor.name} Activity Log')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('contributorEmail', isEqualTo: contributor.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var activityDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: activityDocs.length,
            itemBuilder: (context, index) {
              var booking = activityDocs[index];
              return ListTile(
                title: Text('Solid Food: ${booking['solidFood']} kg'),
                subtitle: Text('Liquid Food: ${booking['liquidFood']} kg'),
                trailing: Text('Date: ${booking['timestamp'].toDate().toString()}'),
              );
            },
          );
        },
      ),
    );
  }
}
