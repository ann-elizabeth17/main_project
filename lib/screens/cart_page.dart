import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/order_payment_options.dart';
import 'package:main_project/screens/profile_page.dart';
import 'package:main_project/screens/wishlist_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  int _selectedIndex = 2; // Wishlist page selected by default
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  // Calculate total price
  double _calculateTotalPrice(List<Map<String, dynamic>> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      total += double.parse(item['price']) * item['quantity'];
    }
    return total;
  }

  Future<void> _saveTotalPrice(double totalPrice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalPrice', totalPrice);
  }

  // Update quantity in Firestore
  void _updateQuantity(String itemId, int quantity) {
    FirebaseFirestore.instance.collection('userCartItems').doc(itemId).update({
      'quantity': quantity,
    });
  }

  // Handle Bottom Navigation Bar taps
  void _onBottomBarTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective pages
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid,)));
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WishlistPage()),
      );
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartPage()));
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: _user == null
          ? const Center(child: Text("Please log in to view your cart"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userCartItems')
                  .where('uid', isEqualTo: _user!.uid)
                  .snapshots(), // Real-time stream of cart items
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Your cart is empty"));
                }

                List<Map<String, dynamic>> cartItems = snapshot.data!.docs.map((doc) {
                  return {
                    'id': doc.id,
                    'title': doc['title'],
                    'price': doc['price'],
                    'imagePath': doc['imagePath'],
                    'quantity': doc['quantity'],
                  };
                }).toList();

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.network(item['imagePath'], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item['title']),
                        subtitle: Text("Price: ₹${item['price']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item['quantity'] > 1) {
                                  _updateQuantity(item['id'], item['quantity'] - 1);
                                }
                              },
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _updateQuantity(item['id'], item['quantity'] + 1);
                              },
                            ),
                            // Remove item icon
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.black), // Close (Remove) icon
                              onPressed: () async {
                                // Remove the item from Firestore collection 'userCartItems'
                                await FirebaseFirestore.instance
                                    .collection('userCartItems')
                                    .doc(item['id'])  // Access the item using its document ID
                                    .delete()  // Delete the item from the collection
                                    .then((_) {
                                      // Optionally, show a Snackbar or update UI after removal
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Item removed from cart"))
                                      );
                                    })
                                    .catchError((error) {
                                      // Handle any errors here
                                      print("Error removing item from cart: $error");
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userCartItems')
                  .where('uid', isEqualTo: _user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }

                List<Map<String, dynamic>> cartItems = snapshot.data!.docs.map((doc) {
                  return {
                    'id': doc.id,
                    'title': doc['title'],
                    'price': doc['price'],
                    'quantity': doc['quantity'],
                  };
                }).toList();

                double total = _calculateTotalPrice(cartItems);

                 _saveTotalPrice(total);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to checkout page
                 Navigator.push(
                   context, 
                   MaterialPageRoute(builder: (context) => OrderPaymentOption())
                 );
              },
              child: const Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onBottomBarTapped,
              selectedItemColor: Color.fromARGB(255, 43, 11, 11),
              unselectedItemColor: Color.fromARGB(255, 43, 11, 11),
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
    );
  }
}
