import 'package:flutter/material.dart';
import 'package:main_project/screens/admin/beverage_page.dart';
import 'package:main_project/screens/admin/breads_page.dart';
import 'package:main_project/screens/admin/desserts_page.dart';
import 'package:main_project/screens/admin/non_vegetarian_page.dart';
import 'package:main_project/screens/admin/rice_page.dart';
import 'package:main_project/screens/admin/street_foods_page.dart';
import 'package:main_project/screens/admin/vegetarian_page.dart';

class ManageMenusPage extends StatelessWidget {
  const ManageMenusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuOptions = [
      {'title': 'Street Foods', 'icon': Icons.fastfood, 'page': StreetFoodsPage()},
      {'title': 'Vegetarian', 'icon': Icons.emoji_food_beverage, 'page': VegetarianPage()},
      {'title': 'Non-Vegetarian', 'icon': Icons.restaurant, 'page': NonVegetarianPage()},
      {'title': 'Rice', 'icon': Icons.rice_bowl, 'page': RicePage()},
      {'title': 'Breads', 'icon': Icons.local_dining, 'page': BreadsPage()},
      {'title': 'Desserts', 'icon': Icons.cake, 'page': DessertsPage()},
      {'title': 'Beverages', 'icon': Icons.local_drink, 'page': BeveragePage()},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Manage Menus'),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Menu',
              style: TextStyle(
                fontSize: 22.0,  // Reduced font size
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 11, 11),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,  // Changed to 3 columns per row
                  crossAxisSpacing: 10.0,  // Reduced spacing between columns
                  mainAxisSpacing: 10.0,  // Reduced spacing between rows
                ),
                itemCount: menuOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => menuOptions[index]['page']),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.0),  // Reduced border radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4.0,  // Reduced blur radius
                            spreadRadius: 3.0,  // Reduced spread radius
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(menuOptions[index]['icon'], size: 40, color: const Color.fromARGB(255, 43, 11, 11)),  // Reduced icon size
                          const SizedBox(height: 8),  // Reduced space between icon and text
                          Text(
                            menuOptions[index]['title'],
                            style: const TextStyle(
                              fontSize: 14.0,  // Reduced font size
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

