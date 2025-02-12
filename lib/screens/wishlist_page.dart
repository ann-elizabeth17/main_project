import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/screens/cart_page.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/profile_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _selectedIndex = 1; // Wishlist page selected by default
  String? uid;

  @override
  void initState() {
    super.initState();
    _fetchUserUID();
  }

  // Fetch the UID of the current logged-in user
  Future<void> _fetchUserUID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('registrationUser')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          uid = userDoc.id;
        });
      }
    }
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
        title: const Text("My Wishlist"),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: uid == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userWishlist')
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No items in the wishlist."));
                }

                final wishlistItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index].data() as Map<String, dynamic>;
                    return Container(
                      height: 100,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 43, 11, 11).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child:  ListTile(
                      leading: Image.network(
                        item['imagePath'],
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['title']),
                      subtitle: Text("\u20B9${item['price']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('userWishlist')
                              .doc(wishlistItems[index].id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Item removed from wishlist")),
                          );
                        },
                      ),
                    ),
                    );
                  },
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onBottomBarTapped,
              selectedItemColor: Color.fromARGB(255, 43, 11, 11),
              unselectedItemColor: Color.fromARGB(255, 43, 11, 11),
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
    );
  }
}

// Function to add an item to the wishlist
Future<void> addToWishlist(String uid, String title, String price, String imagePath) async {
  final wishlistCollection = FirebaseFirestore.instance.collection('userWishlist');

  // Add item to Firestore
  await wishlistCollection.add({
    'uid': uid,
    'title': title,
    'price': price,
    'imageUrl': imagePath,
  });
}

// Example usage: Call this method from FoodDescriptionPage
void handleAddToWishlist(String title, String price, String imagePath) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = await FirebaseFirestore.instance
        .collection('registrationUser')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final uid = userDoc.id;
      await addToWishlist(uid, title, price, imagePath);
    }
  }
}
