import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main_project/screens/order_confirmation_page.dart';

class CreditCardsPage extends StatelessWidget {
  final double totalPrice;
  CreditCardsPage({Key? key, required this.totalPrice}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Credit Card',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image11.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Credit Card Container
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    width: 400,
                    height: 220,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 41, 10, 10),
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 95, 12, 12), Color.fromARGB(255, 83, 35, 33)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(), // Placeholder for alignment
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/cardcredit.png',
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'BANK NAME',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Card no',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              '1234  5678  9876  5432',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Account Holder',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      'CARDHOLDER',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expiry',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      'MM/YY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(), // Placeholder for alignment
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                const Text(
                                  'Credit Card',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),

                // Account Holder Name and Input Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey, // Assign form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Account Holder Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Account Holder'),
                              hintText: 'Enter Account Holder Name',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Card Number';
                              } else if (value.replaceAll(' ', '').length != 16 ||
                                  !RegExp(r'^\d{4} \d{4} \d{4} \d{4}$').hasMatch(value)) {
                                return 'Card number must be 16 digits';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Card Number'),
                              hintText: 'XXXX XXXX XXXX XXXX',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                              LengthLimitingTextInputFormatter(16), // Limit input to 16 digits + 3 spaces
                              _CardNumberInputFormatter(), // Custom formatter for spaces
                            ],
                          ),
                          const SizedBox(height: 25.0),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expiry',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            items: List.generate(12, (index) {
                                              String month = (index + 1).toString().padLeft(2, '0');
                                              return DropdownMenuItem(
                                                value: month,
                                                child: Text(month),
                                              );
                                            }),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              hintText: 'MM',
                                              border: OutlineInputBorder(),
                                            ),
                                            dropdownColor: Colors.white,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            items: List.generate(10, (index) {
                                              String fullYear = (DateTime.now().year + index).toString();
                                              String year = fullYear.substring(2); // Get last two digits
                                              return DropdownMenuItem(
                                                value: year,
                                                child: Text(year),
                                              );
                                            }),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              hintText: 'YY',
                                              border: OutlineInputBorder(),
                                            ),
                                            dropdownColor: Colors.white,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'CVV',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    TextFormField(
                                      obscureText: true, // Hides the input for security
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter CVV';
                                        } else if (value.length != 3 || !RegExp(r'^\d{3}$').hasMatch(value)) {
                                          return 'CVV must be 3 digits';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number, // Ensures numeric keyboard on input
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                        LengthLimitingTextInputFormatter(3), // Limit input length to 3
                                      ],
                                      decoration: InputDecoration(
                                        hintText: '•••',
                                        hintStyle: const TextStyle(
                                          color: Colors.black26,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationPage(), 
                          ),
                        );
                      };
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 44, 10, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Pay ₹${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all spaces and format input
    String digits = newValue.text.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      // Add a space after every 4 digits (except the last group)
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) {
        formatted += ' ';
      }
    }

    // Return the formatted value
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}