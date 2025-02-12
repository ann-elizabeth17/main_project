import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/home_screen.dart';

class SecondWelcomeScreen extends StatelessWidget {
  const SecondWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Reduced Opacity
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(child: 
                 Image.asset(
              'assets/images/image5.png',  // Ensure the image is in your assets folder
              fit: BoxFit.cover,
            ),),
          Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                ),
              ],
            ),
          ),
          // Text in the top left corner
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'Hello Welcome!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Centered Containers with Food Images and Text in a Row
          Positioned(
            top: MediaQuery.of(context).size.height * 0.27, // Moved slightly downwards
            left: 20,
            right: 20,
            child: Column(
              children: [
                SizedBox(
                  height: 250, // Adjust the height for the containers
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                  foodContainer('assets/images/pavbhaji.jpg', 'Pav Bhaji', context),
                  foodContainer('assets/images/panipuri.jpeg', 'Pani Puri', context),
                  foodContainer('assets/images/bhelpuri.jpg', 'Bhelpuri', context),
                  ],
                  ),
                ),
                SizedBox(height: 20), 
                Text(
                  'Food Menu', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                ),),
                transparentContainer(context), // Arrow container in the next row
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget foodContainer(String imagePath, String name, BuildContext context) {
    return Container(
      width: 220, // Set the width for each container
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, // White background for each container
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 170, // Adjust the height of the image
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          // Food Name Text
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget transparentContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid,)),
         );
      },
      child: Container(
        width: 80, // Adjusted size for the new row
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}