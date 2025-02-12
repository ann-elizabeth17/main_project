import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_description_page.dart';
import 'wishlist_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FoodItem> _filteredFoods = [];

  final Map<String, String> foodCategories = {
    'Street Food': 'streetFoods',
    'Vegetarian': 'vegetarian',
    'Non-Vegetarian': 'nonVegetarian',
    'Rice': 'rice',
    'Breads': 'breads',
    'Desserts': 'desserts',
    'Beverages': 'beverages',
  };

  @override
  void initState() {
    _tabController = TabController(length: foodCategories.keys.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomBarTapped(int index) {
    if (index == _selectedIndex) return; // Prevent reloading the current page
    setState(() {
      _selectedIndex = index;
    });

    // Get the current user ID
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is signed in.");
      return;
    }

    final userId = user.uid;

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: userId),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WishlistPage()),
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
          builder: (context) => ProfilePage(userId: userId), // Pass userId here
        ),
      );
    }
  }

  Future<List<FoodItem>> fetchFoodItems(String collectionName, {String query = ''}) async {
    final snapshot = await FirebaseFirestore.instance.collection(collectionName).get();
    final allFoods = snapshot.docs.map((doc) {
      final data = doc.data();
      return FoodItem(
        title: data['title'] ?? 'Untitled',
        imagePath: data['imageUrl'] ?? '', // Cloudinary URL from Firestore
        price: data['price'] ?? '0',
        description: data['description'] ?? '',
        ingredients: Map<String, String>.from(data['ingredients'] ?? {}),
        nutrition: Map<String, String>.from(data['nutrition'] ?? {}),
        isAvailable: data['isAvailable'] ?? false,
        rating: (data['rating']?.toDouble() ?? 0.0),
        reviews: List.from(data['reviews'] ?? []),
        deliveryDetails: data['deliveryDetails'] ?? '',
      );
    }).toList();

    if (query.isEmpty) {
      return allFoods;
    } else {
      return allFoods.where((food) => food.title.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.sort_rounded, color: const Color.fromARGB(255, 43, 11, 11).withOpacity(0.7), size: 35),
                  Icon(Icons.notifications, color: const Color.fromARGB(255, 43, 11, 11).withOpacity(0.7), size: 35),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                "Bringing the Heart of North India to Your Plate.",
                style: GoogleFonts.macondo(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromARGB(255, 43, 11, 11),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 11, 11),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "North Indian Cuisine, Crafted to Perfection.",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15),
                    contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                labelColor: const Color.fromARGB(255, 43, 11, 11),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color.fromARGB(255, 43, 11, 11),
                isScrollable: true,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: foodCategories.keys.map((category) => Tab(text: category)).toList(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: foodCategories.values.map((collectionName) {
                    return FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems(collectionName, query: _searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No items available"));
                        }
                        final foods = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            final food = foods[index];
                            return RecipeCard(foodItem: food);
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
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
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class RecipeCard extends StatefulWidget {
  final FoodItem foodItem;

  const RecipeCard({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.foodItem.isAvailable) {
          // Navigate to FoodDescriptionPage with foodItem data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDescriptionPage(
                imagePath: widget.foodItem.imagePath,
                title: widget.foodItem.title,
                price: widget.foodItem.price,
                description: widget.foodItem.description,
                ingredients: widget.foodItem.ingredients,
                nutrition: widget.foodItem.nutrition,
                isAvailable: widget.foodItem.isAvailable,
                rating: widget.foodItem.rating,
                reviews: widget.foodItem.reviews,
                deliveryDetails: widget.foodItem.deliveryDetails,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This item is currently out of stock!")),
          );
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovered
                ? [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Image.network(
                    widget.foodItem.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                if (!widget.foodItem.isAvailable)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: Text(
                        "Out of Stock",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (widget.foodItem.isAvailable)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 43, 11, 11).withOpacity(0.7),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                if (widget.foodItem.isAvailable)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.foodItem.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹${widget.foodItem.price}",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodItem {
  final String title;
  final String imagePath;
  final String price;
  final String description;
  final Map<String, String> ingredients;
  final Map<String, String> nutrition;
  final bool isAvailable;
  final double rating;
  final List reviews;
  final String deliveryDetails;

  FoodItem({
    required this.title,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.nutrition,
    required this.isAvailable,
    required this.rating,
    required this.reviews,
    required this.deliveryDetails,
  });
}