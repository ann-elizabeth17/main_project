import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodDescriptionPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final Map<String, String> ingredients;
  final Map<String, String> nutrition;
  final bool isAvailable;
  final double rating;
  final List reviews; // List of reviews
  final String deliveryDetails;

  const FoodDescriptionPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.nutrition,
    required this.isAvailable,
    required this.rating,
    required this.reviews, // Pass reviews list
    required this.deliveryDetails,
  }) : super(key: key);

  @override
  State<FoodDescriptionPage> createState() => _FoodDescriptionPageState();
}

class _FoodDescriptionPageState extends State<FoodDescriptionPage> {
  bool isWishlistAdded = false;
  bool isInCart = false;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
    _checkCartStatus();
  }

  // Check if the item is already in the wishlist
  Future<void> _checkWishlistStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('registrationUser')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final uid = userDoc.id;

        final wishlistItems = await FirebaseFirestore.instance
            .collection('userWishlist')
            .where('uid', isEqualTo: uid)
            .where('title', isEqualTo: widget.title)
            .get();

        setState(() {
          isWishlistAdded = wishlistItems.docs.isNotEmpty;
        });
      }
    }
  }

  // Check if the item is already in the cart
  Future<void> _checkCartStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartItems = await FirebaseFirestore.instance
          .collection('userCartItems')
          .where('uid', isEqualTo: user.uid)
          .where('title', isEqualTo: widget.title)
          .get();

      setState(() {
        isInCart = cartItems.docs.isNotEmpty;
      });
    }
  }

  // Save or remove item from the wishlist
  Future<void> _saveWishlistStatus(bool status) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('registrationUser')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final uid = userDoc.id;

        if (status) {
          // Add item to Firestore wishlist
          await FirebaseFirestore.instance.collection('userWishlist').add({
            'uid': uid,
            'title': widget.title,
            'price': widget.price,
            'imagePath': widget.imagePath,
          });
        } else {
          // Remove item from Firestore wishlist
          final wishlistItems = await FirebaseFirestore.instance
              .collection('userWishlist')
              .where('uid', isEqualTo: uid)
              .where('title', isEqualTo: widget.title)
              .get();

          for (var doc in wishlistItems.docs) {
            await doc.reference.delete();
          }
        }
      }
    }
  }

  // Add item to cart
  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartItemRef = FirebaseFirestore.instance.collection('userCartItems').doc();

      await cartItemRef.set({
        'uid': user.uid,
        'title': widget.title,
        'price': widget.price,
        'imagePath': widget.imagePath,
        'quantity': 1, // Assuming the default quantity is 1
      });

      setState(() {
        isInCart = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added to cart")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add items to the cart")),
      );
    }
  }

  // Remove item from cart
  Future<void> _removeFromCart() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartItems = await FirebaseFirestore.instance
          .collection('userCartItems')
          .where('uid', isEqualTo: user.uid)
          .where('title', isEqualTo: widget.title)
          .get();

      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }

      setState(() {
        isInCart = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed from cart")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.imagePath,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: InteractiveViewer(
                          child: Image.network(widget.imagePath),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 43, 11, 11)),
                  ),
                  Text(
                    "\u20B9${widget.price}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 43, 11, 11)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildIngredientsSection(),
              const SizedBox(height: 16),
              _buildNutritionSection(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    widget.isAvailable ? "Available" : "Out of Stock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.deliveryDetails,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: widget.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.rating}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildReviewsSection(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.isAvailable && !isInCart
                        ? _addToCart
                        : (isInCart ? _removeFromCart : null),
                    icon: isInCart
                        ? const Icon(Icons.remove_shopping_cart)
                        : const Icon(Icons.shopping_cart_outlined),
                    label: Text(isInCart ? "Remove from Cart" : "Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 43, 11, 11),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.isAvailable
                        ? () {
                            setState(() {
                              isWishlistAdded = !isWishlistAdded;
                              _saveWishlistStatus(isWishlistAdded);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              isWishlistAdded
                                  ? const SnackBar(
                                      content: Text("Item added to wishlist"))
                                  : const SnackBar(
                                      content:
                                          Text("Item removed from wishlist")),
                            );
                          }
                        : null,
                    icon: isWishlistAdded
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                    label: Text(isWishlistAdded
                        ? "Added to Wishlist"
                        : "Add to Wishlist"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWishlistAdded
                          ? Colors.grey
                          : const Color.fromARGB(255, 43, 11, 11),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ingredients:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 5,
          children: widget.ingredients.entries.map((entry) {
            return Chip(
              label: Text("${entry.key}: ${entry.value}",
                  style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nutrition:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...widget.nutrition.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reviews:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (widget.reviews.isNotEmpty)
          ...widget.reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(review,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList()
        else
          const Text("No reviews yet.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      ],
    );
  }
}
