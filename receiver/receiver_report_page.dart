import 'package:flutter/material.dart';

class ReceiverReportPage extends StatelessWidget {
  final String receiverName;
  final String email;
  final String address;
  final double solidFood;
  final double liquidFood;
  final String foodDescription;

  const ReceiverReportPage({
    Key? key,
    required this.receiverName,
    required this.email,
    required this.address,
    required this.solidFood,
    required this.liquidFood,
    required this.foodDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receiver Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receiver Name: $receiverName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: $email'),
            SizedBox(height: 8),
            Text('Address: $address'),
            SizedBox(height: 8),
            Text('Solid Food: ${solidFood.toStringAsFixed(2)} kg'),
            SizedBox(height: 8),
            Text('Liquid Food: ${liquidFood.toStringAsFixed(2)} liters'),
            SizedBox(height: 8),
            Text('Food Description: $foodDescription'),
          ],
        ),
      ),
    );
  }
}
