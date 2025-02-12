import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/your_orders_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated image using Lottie
              Lottie.asset(
                'assets/videos/orderconfirmed.json', // Make sure to add this file in assets
                height: 400, // Adjusted height for reduced space
                width: 500,
              ),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 43, 11, 11),
                ),
              ),
              const Text(
                'Thank you for your order!',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(204, 43, 11, 11)),
              ),
                const Text(
                  'Your delicious meal is being prepared and will be on its',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(204, 43, 11, 11)),
                ),
                const Text(
                  'way soon. Track your order anytime in the app.',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(204, 43, 11, 11)),
                ),
              const SizedBox(height: 20), // Adjusted space for buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => YourOrdersPage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 43, 11, 11), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(width: 15), // Space between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid,))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 43, 11, 11), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Go Back Home', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
