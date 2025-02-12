import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/payment_processing_page.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;
  String userName = '';
  String userEmail = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndCart();
  }

  // Load user and cart data from Firestore
  void _loadUserDataAndCart() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Fetch user details from Firestore
        DocumentSnapshot userSnapshot = await firestore
            .collection('registrationUser')
            .doc(currentUser.uid)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            userName = userSnapshot['full_name'] ?? '';
            userEmail = userSnapshot['email'] ?? '';
          });
        }

        // Fetch cart items from Firestore
        QuerySnapshot cartSnapshot = await firestore
            .collection('userCartItems')
            .where('uid', isEqualTo: currentUser.uid)
            .get();

        setState(() {
          cartItems = cartSnapshot.docs.map((doc) {
            return {
              'title': doc['title'],
              'price': doc['price'].toString(),
              'quantity': doc['quantity'],
              'imagePath': doc['imagePath'],
            };
          }).toList();

          totalPrice = cartItems.fold(
            0.0,
            (total, item) =>
                total + (double.parse(item['price']) * item['quantity']),
          );
        });
      }
    } catch (e) {
      print('Error loading user or cart data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _proceedToPay() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Add items to 'userPlacedOrders' collection
        for (var item in cartItems) {
          await firestore.collection('userPlacedOrders').add({
            'uid': currentUser.uid,
            'title': item['title'],
            'price': item['price'],
            'quantity': item['quantity'],
            'imagePath': item['imagePath'],
            'status': 'Order Placed', // New field
          });
        }

        // Remove items from 'userCartItems' collection
        QuerySnapshot cartSnapshot = await firestore
            .collection('userCartItems')
            .where('uid', isEqualTo: currentUser.uid)
            .get();

        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete();
        }

        // Navigate to the Payment Processing Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentProcessingPage()),
        );
      }
    } catch (e) {
      print('Error during proceed to pay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/image10.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Page Content
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Order Confirmation',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 43, 11, 11),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Items List
                              Expanded(
                                child: cartItems.isEmpty
                                    ? const Center(
                                        child: Text('No items in cart.'),
                                      )
                                    : ListView.builder(
                                        itemCount: cartItems.length,
                                        itemBuilder: (context, index) {
                                          final item = cartItems[index];
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.network(
                                                  item['imagePath'],
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item['title'],
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₹${item['price']} x ${item['quantity']}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Subtotal: ₹${(double.parse(item['price']) * item['quantity']).toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              const SizedBox(height: 20),

                              // Delivery Time Expectation Messages
                              const Text(
                                "Delivery Information:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "• Your order is expected to deliver within half an hour of the order confirmation time.",
                                style: TextStyle(fontSize: 16),
                              ),
                              const Text(
                                "• We offer standard shipping via courier services in every South Indian State near you, ensuring your order is delivered safely at the provided address within the estimated time frame.",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),

                              // Total Price and Proceed Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 43, 11, 11),
                                    ),
                                    onPressed: _proceedToPay,
                                    child: const Text('Proceed to Pay'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
