import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/cart_page.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/order_tracking_page.dart';
import 'package:main_project/screens/profile_page.dart';
import 'package:main_project/screens/wishlist_page.dart';

class YourOrdersPage extends StatefulWidget {
  const YourOrdersPage({Key? key}) : super(key: key);

  @override
  State<YourOrdersPage> createState() => _YourOrdersPageState();
}

class _YourOrdersPageState extends State<YourOrdersPage> {
  int _selectedIndex = 3;
  List<Map<String, dynamic>> currentOrders = [];
  List<Map<String, dynamic>> previousOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch orders for the current user from Firestore
  Future<void> _fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return; // No user logged in
    }

    try {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('userPlacedOrders')
          .where('uid', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> fetchedOrders = ordersSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'title': data['title'],
          'price': data['price'],
          'imagePath': data['imagePath'],
          'quantity': data['quantity'],
          'status': data['status'],
          'orderId': doc.id, // Use Firestore document ID as order ID
        };
      }).toList();

      setState(() {
        currentOrders = fetchedOrders
            .where((order) => order['status'] != 'Delivered' && order['status'] != 'Cancelled')
            .toList();
        previousOrders = fetchedOrders
            .where((order) => order['status'] == 'Delivered' || order['status'] == 'Cancelled')
            .toList();
      });
    } catch (e) {
      // Handle error
      print('Error fetching orders: $e');
    }
  }

  // Navigate to Order Details Page
  void _navigateToOrderDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingPage(orderId: order['orderId']),
      ),
    );
  }

  void _onBottomBarTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                )),
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
            builder: (context) => ProfilePage(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          if (currentOrders.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Track Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _buildOrderList(currentOrders),
          ],
          if (previousOrders.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Previous Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _buildOrderList(previousOrders),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomBarTapped,
        selectedItemColor: const Color.fromARGB(255, 43, 11, 11),
        unselectedItemColor: const Color.fromARGB(255, 43, 11, 11),
        backgroundColor: Colors.black,
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
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return GestureDetector(
          onTap: () => _navigateToOrderDetails(order),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order['imagePath'] ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['title'] ?? 'Unknown Item',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: ₹${order['price']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Quantity: ${order['quantity']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: ₹${(double.parse(order['price'].toString()) * order['quantity']).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${order['status']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: order['status'] == 'Cancelled'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
