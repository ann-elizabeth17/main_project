import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Issue {
  final String userName;
  final String phoneNumber;
  final String problemType;
  final String problemDescription;
  final String userEmail;
  String? adminReply;
  bool isAddressed;
  final String documentId;

  Issue({
    required this.userName,
    required this.phoneNumber,
    required this.problemType,
    required this.problemDescription,
    required this.userEmail,
    required this.documentId,
    this.adminReply,
    this.isAddressed = false,
  });

  factory Issue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Issue(
      userName: data['name'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      problemType: data['problem_type'] ?? '',
      problemDescription: data['description'] ?? '',
      userEmail: data['email'] ?? '',
      adminReply: data['adminReply'],
      isAddressed: data['isAddressed'] ?? false,
      documentId: doc.id,
    );
  }
}

class ManageQueriesPage extends StatefulWidget {
  @override
  _ManageQueriesPageState createState() => _ManageQueriesPageState();
}

class _ManageQueriesPageState extends State<ManageQueriesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showReplyDialog(Issue issue) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reply to ${issue.userName}'),
          content: TextField(
            controller: replyController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your reply...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Send Reply'),
              onPressed: () {
                _firestore.collection('userReportProblems').doc(issue.documentId).update({
                  'adminReply': replyController.text,
                  'isAddressed': true,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reply sent successfully')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        title: Text('Issue Management', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('userReportProblems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading issues'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No issues reported.'));
          }

          final issues = snapshot.data!.docs.map((doc) => Issue.fromFirestore(doc)).toList();

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: issues.length,
            itemBuilder: (context, index) {
              return _buildIssueContainer(issues[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildIssueContainer(Issue issue) {
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
          _buildSectionTitle('Issue Details'),
          _buildDetailRow('User Name', issue.userName),
          _buildDetailRow('Phone Number', issue.phoneNumber),
          _buildDetailRow('Email', issue.userEmail),
          _buildDetailRow('Problem Type', issue.problemType),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Problem Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 11, 11),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              issue.problemDescription,
              style: TextStyle(color: Colors.black87),
            ),
          ),

          if (issue.adminReply != null) ...[
            _buildSectionTitle('Admin Reply'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                issue.adminReply!,
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          ],

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: issue.isAddressed
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: null,
                    child: Text('Issue Addressed'),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 43, 11, 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Reply to Issue',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _showReplyDialog(issue),
                  ),
          ),
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
}
