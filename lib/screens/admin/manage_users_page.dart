import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User model to represent user data
class User {
  final String fullName;
  final String phone;
  final String email;
  final String birthday;
  final List<Map<String, String>> addresses; // List of maps to handle multiple addresses
  final String profileImageUrl;
  final String password;
  final String role;
  final String uid;

  User({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.addresses,
    required this.profileImageUrl,
    required this.password,
    required this.role,
    required this.uid,
  });

  // Convert Firestore data to User model
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Explicitly mapping the list of addresses to a list of maps with String keys and values
    List<Map<String, String>> addresses = [];
    if (data['addresses'] != null) {
      for (var address in data['addresses']) {
        // Manually mapping the address data
        addresses.add({
          'address': address['address'] ?? '',
          'landmark': address['landmark'] ?? '',
          'pincode': address['pincode'] ?? '',
        });
      }
    }

    return User(
      fullName: data['full_name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      birthday: data['birthday'] ?? '',
      addresses: addresses,
      profileImageUrl: data['imageUrl'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
      uid: data['uid'] ?? '',
    );
  }
}

class ManageUsersPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<ManageUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        title: Text('User Management', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('registrationUser').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs
              .map((doc) => User.fromFirestore(doc))
              .toList();

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserContainer(users[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserContainer(User user) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Image
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 43, 11, 11),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
            ),
          ),
          
          // Personal Information
          _buildSectionTitle('Personal Information'),
          _buildDetailRow('Full Name', user.fullName),
          _buildDetailRow('Phone', user.phone),
          _buildDetailRow('Email', user.email),
          _buildDetailRow('Birthday', user.birthday),

          // Address Details
          _buildSectionTitle('Address Details'),
          _buildAddressDetails(user.addresses),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 43, 11, 11),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Method to display address details
  Widget _buildAddressDetails(List<Map<String, String>> addresses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: addresses.map((address) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address: ${address['address']}'),
              Text('Landmark: ${address['landmark']}'),
              Text('Pincode: ${address['pincode']}'),
              SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}
