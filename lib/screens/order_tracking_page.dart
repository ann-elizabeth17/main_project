import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_project/screens/cart_page.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/profile_page.dart';
import 'package:main_project/screens/wishlist_page.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId; // Accept orderId as a parameter

  // Constructor to accept orderId
  const OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  int _selectedIndex = 3;
  int currentStatusIndex = 0;

  final List<String> statuses = [
    'Order Placed',
    'Preparing',
    'Out for Delivery',
    'Delivered',
  ];

  final List<String> statusDescriptions = [
    'Your order has been successfully placed \n and is being processed.',
    'We are preparing your order with care \n and attention to detail.',
    'Your order is on its way and will arrive soon!',
    'Your order has been delivered. \n Thank you for choosing us!',
  ];

  final List<String> lottieFiles = [
    'assets/videos/order_placed.json',
    'assets/videos/preparing.json',
    'assets/videos/out_for_delivery.json',
    'assets/videos/delivered.json',
  ];

  late Stream<DocumentSnapshot> _orderStatusStream;

  @override
  void initState() {
    super.initState();

    // Initialize the Firestore listener for order status
    _orderStatusStream = FirebaseFirestore.instance
        .collection('userPlacedOrders')
        .doc(widget.orderId)
        .snapshots();

    // Listen to changes and update the status index
    _orderStatusStream.listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final status = data['status'] as String;

        // Find the index of the current status
        final index = statuses.indexOf(status);
        if (index != -1) {
          setState(() {
            currentStatusIndex = index;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onBottomBarTapped(int index) {
    if (index == _selectedIndex) return; // Prevent reloading the current page
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WishlistPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid)),
      );
    }
  }

  void _showWhatsAppDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('For any enquiries'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Call: +91 1234567890',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Order Tracking',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < statuses.length; i++)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Lottie.asset(
                            lottieFiles[i],
                            repeat: i == currentStatusIndex,
                          ),
                        ),
                        if (i < statuses.length - 1)
                          Container(
                            height: 50,
                            width: 2,
                            color: i < currentStatusIndex
                                ? const Color.fromARGB(255, 43, 11, 11)
                                : Colors.grey,
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statuses[i],
                          style: TextStyle(
                            color: i == currentStatusIndex
                                ? const Color.fromARGB(255, 43, 11, 11)
                                : Colors.grey,
                            fontWeight: i == currentStatusIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        if (i == currentStatusIndex)
                          const Text(
                            'In progress...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        const SizedBox(height: 8),
                        if (i == currentStatusIndex) // Only display description for the current status
                          Text(
                            statusDescriptions[i],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomBarTapped,
        selectedItemColor: const Color.fromARGB(255, 43, 11, 11),
        unselectedItemColor: const Color.fromARGB(255, 43, 11, 11),
        backgroundColor: Colors.black, // Changed bottom bar color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showWhatsAppDialog,
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        child: const Icon(Icons.call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
