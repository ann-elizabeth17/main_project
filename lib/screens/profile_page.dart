import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/screens/cart_page.dart';
import 'package:main_project/screens/edit_profile_page.dart';
import 'package:main_project/screens/forget_password_screen.dart';
import 'package:main_project/screens/help_center_page.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/signin_screen.dart';
import 'package:main_project/screens/wishlist_page.dart';
import 'package:main_project/screens/your_orders_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  String? profileName;
  String? profileImage;
  final Color primaryColor = const Color(0xFF2B0B0B);
  final Color accentColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userId);
  }

  void fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('registrationUser')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          profileName = userDoc['full_name'];
          profileImage = userDoc['imageUrl'];
        });
      } else {
        setState(() {
          profileName = "Guest";
          profileImage = null;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        profileName = "Guest";
        profileImage = null;
      });
    }
  }

  void _onBottomBarTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    final userId = widget.userId;
    Widget nextPage;

    switch (index) {
      case 0:
        nextPage = HomeScreen(userId: userId);
        break;
      case 1:
        nextPage = const WishlistPage();
        break;
      case 2:
        nextPage = CartPage();
        break;
      case 3:
        nextPage = ProfilePage(userId: userId);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _logoutUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Logout failed. Please try again."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Hi, ${profileName ?? "Guest"}!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              // decoration: BoxDecoration(
              //   //color: primaryColor,
              //   borderRadius: const BorderRadius.only(
              //     bottomLeft: Radius.circular(30),
              //     bottomRight: Radius.circular(30),
              //   ),
              // ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      child: profileImage != null
                          ? ClipOval(
                              child: Image.network(
                                profileImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: primaryColor,
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    profileName ?? "Guest",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 10),
                  _buildMenuCard([
                    _buildMenuItem(
                      context,
                      "Edit Profile",
                      Icons.person_outline,
                      EditProfilePage(),
                      showDivider: true,
                    ),
                    _buildMenuItem(
                      context,
                      "Change Password",
                      Icons.lock_outline,
                      const ForgetPasswordScreen(),
                      showDivider: false,
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Orders & Wishlist'),
                  const SizedBox(height: 10),
                  _buildMenuCard([
                    _buildMenuItem(
                      context,
                      "My Orders",
                      Icons.shopping_bag_outlined,
                      const YourOrdersPage(),
                      showDivider: true,
                    ),
                    _buildMenuItem(
                      context,
                      "My Favourites",
                      Icons.favorite_outline,
                      const WishlistPage(),
                      showDivider: false,
                    ),
                  ]),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 10),
                  _buildMenuCard([
                    _buildMenuItem(
                      context,
                      "Help Center",
                      Icons.help_outline,
                      HelpCenterPage(),
                      showDivider: false,
                    ),
                  ]),
                  const SizedBox(height: 30),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onBottomBarTapped,
              selectedItemColor: Color.fromARGB(255, 43, 11, 11),
              unselectedItemColor: Color.fromARGB(255, 43, 11, 11),
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Widget page, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
        if (showDivider)
          Divider(
            height: 0,
            thickness: 1,
            color: Colors.grey[200],
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: _logoutUser,
      ),
    );
  }
}