import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay
import 'package:waste_manage/user_type.dart';

import 'push_notification_service.dart'; // Import for Push Notifications
import 'waste_suggestions.dart'; // Import for Waste Minimization Suggestions

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
  final PushNotificationService _pushNotificationService = PushNotificationService();

  User? _user;
  int contributionCount = 0; // To track number of contributions
  double weeklyWaste = 0; // Track weekly waste for badge

  TextEditingController _solidFoodController = TextEditingController();
  TextEditingController _liquidFoodController = TextEditingController();
  TextEditingController _foodDescriptionController = TextEditingController();

  // Donation-related variables
  TextEditingController _donationAmountController = TextEditingController();
  double donationAmount = 0;
  double costPerMeal = 150.0; // Average cost to feed one person one meal in INR
  int peopleFed = 0;

  Razorpay? _razorpay; // Razorpay instance

  Stream<DocumentSnapshot>? _contributorDataStream;

  double _solidFood = 0;
  double _liquidFood = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Razorpay event listeners
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Initialize Push Notifications
    _pushNotificationService.initFCM();

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserTypePage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _loadContributorData() async {
    _contributorDataStream = _firestore.collection('contributors').doc(_user!.uid).snapshots();

    _contributorDataStream!.listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _solidFood = double.parse(snapshot['solidFood'] ?? '0');
          _liquidFood = double.parse(snapshot['liquidFood'] ?? '0');
          contributionCount = snapshot['contributionCount'] ?? 0;
          weeklyWaste = snapshot['weeklyWaste'] ?? 0;
          _user!.updateDisplayName(snapshot['restaurantName'] ?? '');
        });
      }
    });
  }

  // Integrated Badge Logic based on weeklyWaste
  String _getBadge(double waste) {
    if (waste == 0) {
      return 'Do your first donation';
    } else if (waste < 5) {
      return 'Bronze';
    } else if (waste < 15) {
      return 'Silver';
    } else {
      return 'Gold';
    }
  }

  // Calculate how many people can be fed based on the donation amount
  void _calculatePeopleFed() {
    setState(() {
      donationAmount = double.tryParse(_donationAmountController.text) ?? 0;
      peopleFed = (donationAmount / costPerMeal).floor();
    });
  }

  // Razorpay Payment Logic
  void _startPayment() {
    var options = {
      'key': 'YOUR_RAZORPAY_API_KEY', // Add your Razorpay API key here
      'amount': (donationAmount * 100).toInt(), // Amount is in paise, so convert to INR
      'name': 'Food Waste Project',
      'description': 'Donation to Feed People',
      'prefill': {
        'contact': '9876543210',
        'email': _user?.email ?? '',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment successful!")));
    _donationAmountController.clear();
    setState(() {
      donationAmount = 0;
      peopleFed = 0;
    });
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed!")));
  }

  // Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("External wallet selected: ${response.walletName}")));
  }

  @override
  void dispose() {
    _razorpay!.clear();
    super.dispose();
  }

  void _submitFood() async {
    final data = {
      'solidFood': _solidFoodController.text,
      'liquidFood': _liquidFoodController.text,
      'foodDescription': _foodDescriptionController.text,
      'contributionCount': FieldValue.increment(1),
      'weeklyWaste': FieldValue.increment(double.tryParse(_solidFoodController.text) ?? 0),
    };

    await _firestore.collection('contributors').doc(_user!.uid).set(
          data,
          SetOptions(merge: true),
        );

    // Send push notification to admins
    _pushNotificationService.sendNotificationToTopic(
      'New Contribution',
      'A new food contribution has been submitted!',
      'admin',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Food data submitted successfully')),
    );

    _solidFoodController.clear();
    _liquidFoodController.clear();
    _foodDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the badge based on weeklyWaste
    String badge = _getBadge(weeklyWaste);

    // AI suggestion for waste minimization
    WasteMinimizationService suggestionService = WasteMinimizationService();
    String suggestion = suggestionService.getSuggestion(weeklyWaste);

    return Scaffold(
      appBar: AppBar(title: const Text('Contributor Dashboard')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/images3.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_user?.displayName ?? ''}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _user?.email ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your Badge: $badge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  Text(
                    'Waste Minimization Tip: $suggestion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _solidFoodController,
                    decoration: InputDecoration(
                      labelText: 'Solid Food Input (in kg)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  TextFormField(
                    controller: _liquidFoodController,
                    decoration: InputDecoration(
                      labelText: 'Liquid Food Input (in liters)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  TextFormField(
                    controller: _foodDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Food Description',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitFood,
                    child: Text('Submit Food'),
                  ),
                  SizedBox(height: 40),
                  // Donation Section
                  Text(
                    'Donate Money to Feed People',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _donationAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Donation Amount (in ₹)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculatePeopleFed,
                    child: Text('Calculate no. of people you can feed'),
                  ),
                  SizedBox(height: 20),
                  if (donationAmount > 0)
                    Text(
                      'With ₹${donationAmount.toStringAsFixed(2)}, you can provide meals to approximately $peopleFed people.',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startPayment, // Trigger Razorpay payment
                    child: Text('Donate Now'),
                  ),
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
