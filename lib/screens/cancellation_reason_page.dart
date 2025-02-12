import 'package:flutter/material.dart';

class CancellationReasonPage extends StatefulWidget {
  final String foodName;

  CancellationReasonPage({required this.foodName});

  @override
  _CancelOrderPageState createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancellationReasonPage> {
  String? selectedReason;
  TextEditingController customReasonController = TextEditingController();

  final List<String> cancellationReasons = [
    "Changed my mind",
    "Order placed by mistake",
    "Found a better deal elsewhere",
    "Wrong delivery address",
    "Order delay",
    "No longer need the order",
    "Long wait time",
    "Food quality concerns",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancel ${widget.foodName}"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select the reason for canceling the order:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Radio buttons for selecting reason
            Column(
              children: cancellationReasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                      // Clear the custom reason when selecting other options
                      if (selectedReason != "Other") {
                        customReasonController.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            // Show text field if 'Other' is selected
            if (selectedReason == "Other")
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: customReasonController,
                  decoration: InputDecoration(
                    labelText: "Please enter your reason",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
            SizedBox(height: 20), // Add some space before the button
            // Cancel Order Button
            ElevatedButton(
              onPressed: () {
                if (selectedReason != null) {
                  String reasonToSubmit = selectedReason == "Other"
                      ? customReasonController.text
                      : selectedReason!;

                  if (reasonToSubmit.isNotEmpty) {
                    // Pass the selected food name and reason back to the previous page
                    Navigator.pop(context, {
                      'foodName': widget.foodName,
                      'reason': reasonToSubmit,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please provide a reason to cancel the order")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a reason to cancel the order")),
                  );
                }
              },
              child: Text("Cancel Order", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
