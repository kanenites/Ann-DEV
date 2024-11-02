import 'package:flutter/material.dart';

class BadgeSystem {
  String getBadge(int contributions) {
    if (contributions >= 4) {
      return 'Gold Contributor';
    } else if (contributions == 3) {
      return 'Silver Contributor';
    } else if (contributions == 2) {
      return 'Bronze Contributor';
    } else {
      return 'New Contributor';
    }
  }
}

class ContributorDashboard extends StatefulWidget {
  final int contributions;
  final double totalFood;

  ContributorDashboard({
    required this.contributions,
    required this.totalFood,
  });

  @override
  _ContributorDashboardState createState() => _ContributorDashboardState();
}

class _ContributorDashboardState extends State<ContributorDashboard> {
  late BadgeSystem badgeSystem;
  late String badge;

  @override
  void initState() {
    super.initState();
    badgeSystem = BadgeSystem();
    badge = badgeSystem.getBadge(widget.contributions); // Get initial badge
  }

  @override
  void didUpdateWidget(ContributorDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contributions != widget.contributions) {
      // Update badge when contributions change
      setState(() {
        badge = badgeSystem.getBadge(widget.contributions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contributor Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Badge:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              badge,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Contributions: ${widget.contributions}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Total Food Contributed: ${widget.totalFood.toStringAsFixed(2)} kg',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
