import 'package:flutter/material.dart';
import 'package:main_project/screens/admin/manage_menu_page.dart';
import 'package:main_project/screens/admin/manage_queries_page.dart';
import 'package:main_project/screens/admin/manage_users_page.dart';
import 'package:main_project/screens/admin/users_ordering_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/screens/signin_screen.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  // Logout user
  void _logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Logout failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = 'Ann Elizabeth';  // Replace with dynamic user name
    final List<Map<String, dynamic>> options = [
      {'title': 'Manage Menus', 'icon': Icons.restaurant_menu, 'page': const ManageMenusPage()},
      {'title': 'Update Order Status', 'icon': Icons.update, 'page':  UserOrdersPage()},
      {'title': 'Manage User Details', 'icon': Icons.person, 'page':  ManageUsersPage()},
      {'title': 'Manage Queries & Issues', 'icon': Icons.help, 'page':  ManageQueriesPage()},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _logoutUser();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying greeting message
            Text(
              'Hi, $userName',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 11, 11),
              ),
            ),
            const SizedBox(height: 20),  // Add space between greeting and grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => options[index]['page']),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 43, 11, 11).withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 5.0,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(options[index]['icon'], size: 50, color: const Color.fromARGB(255, 43, 11, 11)),
                          const SizedBox(height: 10),
                          Text(
                            options[index]['title'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




