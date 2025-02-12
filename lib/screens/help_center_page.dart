import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Help Center'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.question_answer, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("Frequently Asked Questions (FAQ)"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQPage()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.contact_phone, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("Contact Support"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactSupportPage()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.report, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("Report a Problem"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportProblemPage()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.report_problem, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("Addressed Issues"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserReportPage()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.policy, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("Privacy Policy"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.info_outline, color: Color.fromARGB(255, 43, 11, 11)),
                title: Text("About Us"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Frequently Asked Questions'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("How do I place an order?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("To place an order, select your items and proceed to checkout."),
            ),
            ListTile(
              title: Text("How do I track my order?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("You can track your order status from the order history."),
            ),
            ListTile(
              title: Text("Can I cancel my order?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("You can cancel an order within 5 minutes after placing it, before it is picked up by the delivery driver."),
            ),
            ListTile(
              title: Text("What payment methods do you accept?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("We accept credit/debit cards, mobile wallets (e.g., Apple Pay, Google Pay), and cash on delivery (COD)."),
            ),
            ListTile(
              title: Text("How do I change my delivery address?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("You can update your delivery address in your account settings before placing an order."),
            ),
            ListTile(
              title: Text("Can I schedule a delivery for later?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("Yes, you can select a preferred delivery time during checkout. Some locations may have scheduling limitations."),
            ),
            ListTile(
              title: Text("Do you deliver to my area?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("We currently deliver in the following areas: [Insert your delivery areas]. Please check the delivery options during checkout."),
            ),
            ListTile(
              title: Text("What happens if my order is delayed?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("If your order is delayed, you will be notified and we will try to resolve the issue as quickly as possible."),
            ),
            ListTile(
              title: Text("Can I add special instructions to my order?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("Yes, you can add special instructions or requests for the restaurant in the order notes section during checkout."),
            ),
            ListTile(
              title: Text("How do I contact customer support?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("You can contact support via phone or email from the 'Contact Support' page in the app."),
            ),
            ListTile(
              title: Text("Do you offer discounts or promotions?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("We offer periodic discounts, promo codes, and special offers. Be sure to check the 'Promotions' section or sign up for our newsletter."),
            ),
            ListTile(
              title: Text("Can I reorder a previous order?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("Yes, you can reorder a past order from your order history in the app."),
            ),
            ListTile(
              title: Text("How do I rate my order or the service?", style: TextStyle(color: Color.fromARGB(255, 43, 11, 11), fontWeight: FontWeight.bold),),
              subtitle: Text("After your order is delivered, you will be prompted to rate your experience. You can also leave feedback directly in the app."),
            ),
          ],
        ),
      ),
    );
  }
}


class ContactSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Contact Support'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Contact Methods
            SectionHeader(title: "Contact Us"),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.phone, color: Color.fromARGB(255, 43, 11, 11)),
                      title: Text("Call Us"),
                      subtitle: Text("For urgent issues, you can call our support line. \n +91 98765 43201"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Color.fromARGB(255, 43, 11, 11)),
                      title: Text("Email Us"),
                      subtitle: Text("For general inquiries or non-urgent issues, email us at the address below. \n zaikaenorthtales@zn.in"),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Customer Service Hours
            SectionHeader(title: "Customer Service Hours"),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.access_time, color: Color.fromARGB(255, 43, 11, 11)),
                      title: Text("Available Hours"),
                      subtitle: Text("Monday - Friday: 9 AM - 6 PM (local time)"),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time, color: Color.fromARGB(255, 43, 11, 11)),
                      title: Text("Weekend Support"),
                      subtitle: Text("Saturday - Sunday: 10 AM - 4 PM (local time)"),
                    ),
                    ListTile(
                      leading: Icon(Icons.event_busy, color: Color.fromARGB(255, 43, 11, 11)),
                      title: Text("Holiday Hours"),
                      subtitle: Text("Our support team is unavailable on public holidays."),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Header Widget for Reusability
class SectionHeader extends StatelessWidget {
  final String title;
  
  SectionHeader({required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 43, 11, 11),
        ),
      ),
    );
  }
}

class ReportProblemPage extends StatefulWidget {
  @override
  _ReportProblemPageState createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedProblemType;
  String? uid;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('registrationUser')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            uid = user.uid;
            nameController.text = userDoc['full_name'] ?? '';
            emailController.text = userDoc['email'] ?? '';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (selectedProblemType == null || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('userReportProblems').add({
        'uid': uid,
        'name': nameController.text,
        'phone_number': orderNumberController.text,
        'problem_type': selectedProblemType,
        'description': descriptionController.text,
        'email': emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thank you for reporting the issue. We will get back to you shortly.')),
      );

      // Clear form fields
      orderNumberController.clear();
      descriptionController.clear();
      setState(() {
        selectedProblemType = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    orderNumberController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Report a Problem'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "We’re here to help! Please provide the details of the issue you are experiencing, and we will get back to you as soon as possible.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // User's Name Field
            TextField(
              controller: nameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),

            // Order Number Field
            TextField(
              controller: orderNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20),

            // Problem Type Dropdown
            DropdownButtonFormField<String>(
              value: selectedProblemType,
              decoration: InputDecoration(
                labelText: 'Problem Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: [
                DropdownMenuItem(value: 'Late Delivery', child: Text('Late Delivery')),
                DropdownMenuItem(value: 'Incorrect Order', child: Text('Incorrect Order')),
                DropdownMenuItem(value: 'Payment Issue', child: Text('Payment Issue')),
                DropdownMenuItem(value: 'App Issue', child: Text('App Issue')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedProblemType = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Description Field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description of the Problem',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            // Contact Details Field
            TextField(
              controller: emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 43, 11, 11),
                padding: EdgeInsets.symmetric(vertical: 14.0),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class UserReportPage extends StatefulWidget {
  @override
  _UserReportPageState createState() => _UserReportPageState();
}

class _UserReportPageState extends State<UserReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserUid;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserUid();
  }

  void _fetchCurrentUserUid() {
    final user = _auth.currentUser;
    setState(() {
      currentUserUid = user?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reports'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: currentUserUid == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('userReportProblems')
                  .where('uid', isEqualTo: currentUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No reports found.'));
                }

                final reports = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report =
                        reports[index].data() as Map<String, dynamic>;
                    return _buildReportCard(report);
                  },
                );
              },
            ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', report['email'] ?? 'N/A'),
            _buildDetailRow('Problem Type', report['problem_type'] ?? 'N/A'),
            _buildDetailRow('Description', report['description'] ?? 'N/A'),
            SizedBox(height: 10),
            Text(
              'Admin Reply:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 11, 11),
                fontSize: 16,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 231, 250, 224),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                report['adminReply'] ?? 'No reply yet',
                style: TextStyle(
                  color: report['adminReply'] != null
                      ? Colors.green[800]
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Privacy Policy'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Company Introduction
            Row(
              children: [
                Icon(Icons.privacy_tip, size: 30, color: Color.fromARGB(255, 43, 11, 11)),
                SizedBox(width: 10),
                Text(
                  "Privacy Policy of Zaika-e-North Tales",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "At Zaika-e-North Tales, we are committed to protecting your privacy. This policy explains how we collect, use, and safeguard your personal information.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Section: Data Collection
            SectionHeader1(title: "1. Data Collection", icon: Icons.data_usage),
            SizedBox(height: 10),
            Text(
              "We collect the following types of data to provide and improve our services:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.person, text: "Personal Information: Name, email address, phone number, and delivery address."),
            BulletPoint(icon: Icons.fastfood, text: "Order Details: Items ordered, payment information, and delivery preferences."),
            BulletPoint(icon: Icons.analytics, text: "Usage Data: Interaction with our app, including pages visited and time spent."),

            SizedBox(height: 20),

            // Section: Use of Data
            SectionHeader1(title: "2. How We Use Your Data", icon: Icons.settings),
            SizedBox(height: 10),
            Text(
              "Your data is used solely to enhance your experience and fulfill your orders:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.delivery_dining, text: "To process and deliver your orders accurately."),
            BulletPoint(icon: Icons.support_agent, text: "To provide customer support and resolve issues."),
            BulletPoint(icon: Icons.email, text: "To send promotional offers, if you have opted in."),
            BulletPoint(icon: Icons.insights, text: "To analyze and improve our app and services."),

            SizedBox(height: 20),

            // Section: Sharing of Data
            SectionHeader1(title: "3. Sharing of Data", icon: Icons.share),
            SizedBox(height: 10),
            Text(
              "We share your data only with trusted partners to ensure efficient service delivery:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.motorcycle, text: "Delivery Partners: To ensure your orders reach you on time."),
            BulletPoint(icon: Icons.payment, text: "Payment Gateways: To process secure payments."),
            BulletPoint(icon: Icons.bar_chart, text: "Analytics Tools: To improve app performance and user experience."),

            SizedBox(height: 20),

            // Section: Data Protection
            SectionHeader1(title: "4. Data Protection and Security", icon: Icons.lock),
            SizedBox(height: 10),
            Text(
              "We implement strict measures to safeguard your data:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.vpn_key, text: "Encryption: All sensitive data is encrypted during transmission."),
            BulletPoint(icon: Icons.verified_user, text: "Access Control: Only authorized personnel can access your data."),
            BulletPoint(icon: Icons.security, text: "Regular Audits: We routinely check our systems for vulnerabilities."),

            SizedBox(height: 20),

            // Section: User Rights
            SectionHeader1(title: "5. Your Rights", icon: Icons.how_to_reg),
            SizedBox(height: 10),
            Text(
              "You have the following rights regarding your personal data:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.file_copy, text: "Access: Request a copy of your personal data."),
            BulletPoint(icon: Icons.edit, text: "Correction: Update inaccurate or incomplete data."),
            BulletPoint(icon: Icons.delete, text: "Deletion: Request the deletion of your data."),
            BulletPoint(icon: Icons.cancel, text: "Opt-out: Withdraw consent for marketing communications."),

            SizedBox(height: 20),

            // Section: Updates to Policy
            SectionHeader1(title: "6. Changes to This Policy", icon: Icons.update),
            SizedBox(height: 10),
            Text(
              "Zaika-e-North Tales reserves the right to update this policy. Significant changes will be communicated via email or app notifications.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            // Section: Contact Information
            SectionHeader1(title: "7. Contact Us", icon: Icons.contact_support),
            SizedBox(height: 10),
            Text(
              "If you have any questions or concerns about our privacy policy, please contact us:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            BulletPoint(icon: Icons.email, text: "Email: privacy@zaikaenorthtales.com"),
            BulletPoint(icon: Icons.phone, text: "Phone: +91 98765 43201"),
            BulletPoint(icon: Icons.location_on, text: "Address: Rose Villa, P.O. Box 123, Kottayam, Kerala, India - 686001"),
          ],
        ),
      ),
    );
  }
}

// Reusable Section Header Widget
class SectionHeader1 extends StatelessWidget {
  final String title;
  final IconData icon;

  SectionHeader1({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Color.fromARGB(255, 43, 11, 11)),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Reusable Bullet Point Widget
class BulletPoint extends StatelessWidget {
  final String text;
  final IconData icon;

  BulletPoint({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Color.fromARGB(255, 43, 11, 11)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}



class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('About Us'),
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Zaika-e-North Tales",
              style: GoogleFonts.macondo(fontSize: 30, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 43, 11, 11)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Zaika-e-North Tales was born out of a passion for authentic North Indian cuisine and a desire to bring its rich flavors to the heart of South India. With a deep appreciation for the culinary traditions of the North, we aim to bridge cultural boundaries through food.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            Text(
              "Why We Started?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 11, 11)),
            ),
            SizedBox(height: 10),
            Text(
              "Living in South India (Kerala), we realized that while there are plenty of delicious local delicacies, authentic North Indian flavors were often missing from the food scene. Our team, hailing from diverse backgrounds, shared a common craving for dishes like butter naan, creamy dal makhani, and spicy paneer tikka prepared just the way they are in the North. This motivated us to create a platform where everyone can experience these delicacies without compromise.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            Text(
              "What Makes Us Unique?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 11, 11)),
            ),
            SizedBox(height: 10),
            Text(
              "We prioritize authenticity in every dish we serve. From using traditional spices to partnering with chefs who have mastered North Indian culinary techniques, we ensure that every bite reminds you of the flavors of Punjab, Rajasthan, and Uttar Pradesh. At Zaika-e-North Tales, it’s not just about food; it’s about delivering an experience that feels like home.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            Text(
              "Our Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 11, 11)),
            ),
            SizedBox(height: 10),
            Text(
              "Our mission is to make North Indian cuisine accessible to everyone in South India, offering an unmatched dining experience through the convenience of food delivery. We believe in bringing people together through the love of food, one order at a time.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            Text(
              "Thank You for Choosing Us",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 11, 11)),
            ),
            SizedBox(height: 10),
            Text(
              "We are grateful for the love and support we’ve received from our customers. Your trust inspires us to keep innovating and delivering the best North Indian culinary experience.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 30),

            Center(
              child: Text(
                "Zaika-e-North Tales: Bringing the Heart of North India to Your Plate.",
                style: GoogleFonts.macondo(fontSize: 20,fontWeight: FontWeight.w800, color: Color.fromARGB(220, 43, 11, 11)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


