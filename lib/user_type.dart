import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin/admin_login.dart';
import 'contributor/contributor_login.dart';
import 'receiver/receiver_login.dart'; // Import your Receiver screen

class UserTypePage extends StatelessWidget {
  const UserTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/images.jpeg'), // Background image
              fit: BoxFit.cover, // Adjust the image to cover the whole screen
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), // Optional: Apply a dark overlay
                BlendMode.darken,
            ),
          ),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'Ann-DEV',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 100), // Space between title and buttons
              Text(
                'Sign in as',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40), // Space between text and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Contributor Button
                  _buildUserButton(context, 'Contributor', Color(0xFF89C5F1), const ContributorScreen()),
                  // Admin Button
                  _buildUserButton(context, 'Admin', Color(0xFF71EE66), const AdminScreen()),
                  // Receiver Button
                  _buildUserButton(context, 'Receiver', Color(0xFFFFB74D), const ReceiverLoginPage()), // Add Receiver Screen
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserButton(BuildContext context, String title, Color color, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        width: 250, // Adjusted width for three buttons
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
