import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersPage extends StatefulWidget {
  const UserOrdersPage({Key? key}) : super(key: key);

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('userPlacedOrders');

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    await _ordersCollection.doc(orderId).update({'status': newStatus});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        title: const Text('Users Orders'),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderContainer(order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderContainer(QueryDocumentSnapshot order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              order['imagePath'],
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),
          ),

          // Title and price section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\₹${order['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Status section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Status: ${order['status']}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _getStatusColor(order['status']),
              ),
            ),
          ),

          // Status buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusButton('Order Placed', order),
                  _buildStatusButton('Preparing', order),
                  _buildStatusButton('Out for Delivery', order),
                  _buildStatusButton('Delivered', order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, QueryDocumentSnapshot order) {
    return ElevatedButton(
      onPressed: order['status'] == status
          ? null
          : () => _updateOrderStatus(order.id, status),
      style: ElevatedButton.styleFrom(
        backgroundColor: order['status'] == status
            ? Colors.grey
            : _getStatusColor(status),
      ),
      child: Text(status),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return Colors.blueGrey;
      case 'Preparing':
        return Colors.orange;
      case 'Out for Delivery':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
