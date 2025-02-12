import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_project/screens/payment_success_page.dart';

class PaymentProcessingPage extends StatelessWidget {
  const PaymentProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to another page after 7 seconds
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 180.0, top: 20.0), // Adjust the top padding to move contents upwards
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Lottie file
            SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/videos/paymentprocessing.json', // Add your Lottie animation file here
                repeat: true,
              ),
            ),
            const SizedBox(height: 20),
            // Payment in Progress Text
            Text(
              'Payment in Progress!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 43, 11, 11),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Instruction Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Please wait for a while because it might take a few seconds.',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(207, 43, 11, 11),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

