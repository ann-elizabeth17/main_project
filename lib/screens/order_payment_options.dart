import 'package:flutter/material.dart';
import 'package:main_project/screens/credit_cards_page.dart';
import 'package:main_project/screens/debit_cards_page.dart';
import 'package:main_project/screens/order_confirmation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPaymentOption extends StatefulWidget {
  const OrderPaymentOption({Key? key}) : super(key: key);

  @override
  State<OrderPaymentOption> createState() => _OrderPaymentOptionState();
}

class _OrderPaymentOptionState extends State<OrderPaymentOption> {
  String selectedPaymentMethod = 'Credit Card';
  String? selectedAddress;
  List<String> addresses = []; // Initially empty to test no address case.
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTotalPrice();
    selectedAddress = addresses.isEmpty ? null : addresses[0];
  }

  Future<void> _loadTotalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPrice = prefs.getDouble('totalPrice') ?? 0.0;
    });
  }

  void _editAddress(int index) {
    TextEditingController controller = TextEditingController(text: addresses[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new address'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                addresses[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addAddress() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new address'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (controller.text.isNotEmpty) {
                  addresses.add(controller.text);
                  if (selectedAddress == null && addresses.isNotEmpty) {
                    selectedAddress = addresses[0]; // Default to the first address
                  }
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _removeAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Address'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
                if (selectedAddress == addresses[index]) {
                  selectedAddress = addresses.isNotEmpty ? addresses[0] : null;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    if (selectedAddress == null || selectedAddress!.isEmpty) {
      _showErrorDialog('Please select or add a delivery address.');
      return;
    }
    if (selectedPaymentMethod.isEmpty) {
      _showErrorDialog('Please select a payment method.');
      return;
    }

    // Navigate to the respective payment details collection page
    switch (selectedPaymentMethod) {
      case 'Credit Card':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreditCardsPage(totalPrice: totalPrice),
          ),
        );
        break;
      case 'Debit Card':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DebitCardsPage(totalPrice: totalPrice)),
        );
        break;
      case 'Cash on Delivery':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationPage(),
          ),
        );
        break;
      default:
        _showErrorDialog('Please select a valid payment method.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/image10.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Payment Methods',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 43, 11, 11),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Choose a Payment Method',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.credit_card, color: Color.fromARGB(199, 43, 11, 11)),
                                  title: const Text('Credit Card'),
                                  trailing: Radio(
                                    value: 'Credit Card',
                                    groupValue: selectedPaymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.credit_card_outlined, color: Color.fromARGB(199, 43, 11, 11)),
                                  title: const Text('Debit Card'),
                                  trailing: Radio(
                                    value: 'Debit Card',
                                    groupValue: selectedPaymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.money, color: Color.fromARGB(199, 43, 11, 11)),
                                  title: const Text('Cash on Delivery'),
                                  trailing: Radio(
                                    value: 'Cash on Delivery',
                                    groupValue: selectedPaymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Delivery Address',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          addresses.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'No delivery address found. Please add one.',
                                        style: TextStyle(color: Colors.red, fontSize: 16),
                                      ),
                                      TextButton.icon(
                                        onPressed: _addAddress,
                                        icon: const Icon(Icons.add, color: Colors.blue),
                                        label: const Text('Add Address', style: TextStyle(color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: addresses.length,
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(addresses[index]),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editAddress(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _removeAddress(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 43, 11, 11),
                                ),
                                onPressed: _placeOrder,
                                child: const Text('Place Order'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
