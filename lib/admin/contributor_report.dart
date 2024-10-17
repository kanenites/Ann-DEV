import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContributorData {
  final String name;
  final String email;
  final double solidFood;
  final double liquidFood;
  final String foodDescription;
  final String address;

  ContributorData({
    required this.name,
    required this.email,
    required this.solidFood,
    required this.liquidFood,
    required this.foodDescription,
    required this.address
  });

  factory ContributorData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ContributorData(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      solidFood: double.tryParse(data['solidFood'] ?? '0.0') ?? 0.0,
      liquidFood: double.tryParse(data['liquidFood'] ?? '0.0') ?? 0.0,
      foodDescription: data['foodDescription'] ?? '',
      address: data['address'] ?? ''
    );
  }
}

class ContributorReportPage extends StatelessWidget {
  final ContributorData contributor;

  const ContributorReportPage({required this.contributor, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contributor Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${contributor.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: ${contributor.email}'),
            SizedBox(height: 10),
            Text('Solid Food: ${contributor.solidFood.toStringAsFixed(2)} kg'),
            Text('Liquid Food: ${contributor.liquidFood.toStringAsFixed(2)} liters'),
            SizedBox(height: 10),
            Text('Adress: ${contributor.address}')
          ],
        ),
      ),
    );
  }
}
