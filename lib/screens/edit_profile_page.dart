import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:main_project/screens/home_screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  List<Map<String, String>> savedAddresses = [];
  String selectedImagePath = '';
  String imageUrl = '';
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF2B0B0B);
  final Color accentColor = const Color(0xFFF5F5F5);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
            await _firestore.collection('registrationUser').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            nameController.text = userData['full_name'] ?? '';
            emailController.text = userData['email'] ?? '';
            phoneController.text = userData['phone'] ?? '';
            birthdayController.text = userData['birthday'] ?? '';
            imageUrl = userData['imageUrl'] ?? '';
            if (userData['addresses'] != null) {
              savedAddresses = List<Map<String, String>>.from(userData['addresses']);
            }
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching user data');
    }
    setState(() => isLoading = false);
  }

  Future<void> _uploadImageToCloudinary() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          selectedImagePath = image.path;
          isLoading = true;
        });

        final imageBytes = await image.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        final String url = 'https://api.cloudinary.com/v1_1/dzgn0vkck/image/upload';
        final Map<String, String> fields = {
          'file': 'data:image/jpeg;base64,$base64Image',
          'upload_preset': 'NorthIndianFoodApp',
        };

        final request = http.MultipartRequest('POST', Uri.parse(url))
          ..fields.addAll(fields);

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final responseData = json.decode(responseBody);
          setState(() {
            imageUrl = responseData['secure_url'];
          });
        } else {
          _showErrorSnackBar('Image upload failed');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error uploading image');
    }
    setState(() => isLoading = false);
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('registrationUser').doc(user.uid).set({
          'full_name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'birthday': birthdayController.text,
          'imageUrl': imageUrl,
          'addresses': savedAddresses,
        }, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: user.uid),
          ),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error updating profile');
    }
    setState(() => isLoading = false);
  }

  void _addAddress() {
    if (addressController.text.isNotEmpty &&
        landmarkController.text.isNotEmpty &&
        pinCodeController.text.isNotEmpty) {
      setState(() {
        savedAddresses.add({
          'address': addressController.text,
          'landmark': landmarkController.text,
          'pincode': pinCodeController.text,
        });
      });

      addressController.clear();
      landmarkController.clear();
      pinCodeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Address added successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _showErrorSnackBar('Please fill all address fields');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        birthdayController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //padding: const EdgeInsets.only(bottom: 10),
                  // decoration: BoxDecoration(
                  //   color: primaryColor,
                  //   borderRadius: const BorderRadius.only(
                  //     bottomLeft: Radius.circular(30),
                  //     bottomRight: Radius.circular(30),
                  //   ),
                  // ),
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white24,
                            backgroundImage: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : null,
                            child: imageUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: primaryColor,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _uploadImageToCloudinary,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'Personal Information',
                        [
                          _buildTextField(
                            controller: nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                          ),
                          _buildTextField(
                            controller: phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildTextField(
                            controller: emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _buildTextField(
                            controller: birthdayController,
                            label: 'Birthday',
                            icon: Icons.cake_outlined,
                            readOnly: true,
                            onTap: () => _selectBirthday(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        'Address Information',
                        [
                          _buildTextField(
                            controller: addressController,
                            label: 'Address',
                            icon: Icons.home_outlined,
                          ),
                          _buildTextField(
                            controller: landmarkController,
                            label: 'Landmark',
                            icon: Icons.location_on_outlined,
                          ),
                          _buildTextField(
                            controller: pinCodeController,
                            label: 'Pin Code',
                            icon: Icons.pin_drop_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.add_location, color: Colors.white),
                              label: const Text(
                                "Add Address",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _addAddress,
                            ),
                          ),
                        ],
                      ),
                      if (savedAddresses.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildSection(
                          'Saved Addresses',
                          savedAddresses.map((address) => _buildAddressCard(address)).toList(),
                        ),
                      ],
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            "Update Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _updateProfile,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            color: primaryColor,
            size: 24,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['address'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Landmark: ${address['landmark']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pin Code: ${address['pincode']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 24,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: const Text("Delete Address"),
                    content: const Text(
                      "Are you sure you want to delete this address?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            savedAddresses.remove(address);
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address deleted successfully'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    pinCodeController.dispose();
    birthdayController.dispose();
    super.dispose();
  }
}