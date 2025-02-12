import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class VegetarianPage extends StatelessWidget {
  const VegetarianPage({Key? key}) : super(key: key);

  Future<void> _deleteFood(String id) async {
    await FirebaseFirestore.instance.collection('vegetarian').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        title: const Text('Vegetarian Foods'),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('vegetarian').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No items in Vegetarian Foods',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: data['imageUrl'] != null
                      ? Image.network(data['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(
                    data['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['price']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditFoodPage(
                                foodId: data.id,
                                foodItem: data.data() as Map<String, dynamic>,
                                isEdit: true,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteFood(data.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditFoodPage(isEdit: false),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
      ),
    );
  }
}

class AddEditFoodPage extends StatefulWidget {
  final String? foodId;
  final Map<String, dynamic>? foodItem;
  final bool isEdit;

  const AddEditFoodPage({Key? key, this.foodId, this.foodItem, required this.isEdit}) : super(key: key);

  @override
  _AddEditFoodPageState createState() => _AddEditFoodPageState();
}

class _AddEditFoodPageState extends State<AddEditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _nutritionController;
  late TextEditingController _deliveryDetailsController;
  late TextEditingController _ratingController;
  late TextEditingController _reviewController;
  bool _isAvailable = true;
  html.File? _image;
  String? _imageUrl;
  bool _isLoading = false;

  final String _cloudinaryUrl = "https://api.cloudinary.com/v1_1/dzgn0vkck/image/upload";
  final String _uploadPreset = "NorthIndianFoodApp";

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _titleController = TextEditingController(text: widget.foodItem!['title']);
      _priceController = TextEditingController(text: widget.foodItem!['price']);
      _descriptionController = TextEditingController(text: widget.foodItem!['description']);
      _ingredientsController = TextEditingController(text: widget.foodItem!['ingredients'].toString());
      _nutritionController = TextEditingController(text: widget.foodItem!['nutrition'].toString());
      _deliveryDetailsController = TextEditingController(text: widget.foodItem!['deliveryDetails']);
      _ratingController = TextEditingController(text: widget.foodItem!['rating'].toString());
      _reviewController = TextEditingController(text: widget.foodItem!['reviews']?.join(", ") ?? "");
      _isAvailable = widget.foodItem!['isAvailable'];
      _imageUrl = widget.foodItem?['imageUrl'];
    } else {
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
      _ingredientsController = TextEditingController();
      _nutritionController = TextEditingController();
      _deliveryDetailsController = TextEditingController();
      _ratingController = TextEditingController();
      _reviewController = TextEditingController();
    }
  }

  Future<String?> _uploadImageToCloudinary(html.File image) async {
    try {
      final formData = html.FormData();
      formData.appendBlob('file', image);
      formData.append('upload_preset', _uploadPreset);

      final request = await html.HttpRequest.request(
        _cloudinaryUrl,
        method: 'POST',
        sendData: formData,
      );

      final data = json.decode(request.responseText ?? '');
      if (data['secure_url'] != null) {
        return data['secure_url'];
      } else {
        print('Upload failed: ${data['error']}');
        return null;
      }
    } catch (e) {
      print('Error during image upload: $e');
      return null;
    }
  }

  Future<void> _saveFoodItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    String? imageUrl = _imageUrl;

    if (_image != null) {
      final uploadedImageUrl = await _uploadImageToCloudinary(_image!);
      if (uploadedImageUrl != null) {
        imageUrl = uploadedImageUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    final ingredients = _parseMapFromText(_ingredientsController.text);
    final nutrition = _parseMapFromText(_nutritionController.text);

    final foodData = {
      'title': _titleController.text,
      'price': _priceController.text,
      'description': _descriptionController.text,
      'ingredients': ingredients,
      'nutrition': nutrition,
      'deliveryDetails': _deliveryDetailsController.text,
      'rating': double.tryParse(_ratingController.text) ?? 0,
      'reviews': _reviewController.text.split(',').map((e) => e.trim()).toList(),
      'isAvailable': _isAvailable,
      'imageUrl': imageUrl,
    };

    if (widget.isEdit) {
      await FirebaseFirestore.instance
          .collection('vegetarian')
          .doc(widget.foodId)
          .update({...foodData, 'id': widget.foodId});
    } else {
      final docRef = await FirebaseFirestore.instance.collection('vegetarian').add(foodData);
      await docRef.update({'id': docRef.id});
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  Widget _buildImageDisplay() {
    if (_image != null) {
      final objectUrl = html.Url.createObjectUrlFromBlob(_image!);
      return Image.network(objectUrl, height: 100, fit: BoxFit.cover);
    } else if (_imageUrl != null) {
      return Image.network(
        _imageUrl!,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return const Text('No image selected.');
    }
  }

  void _pickImage() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.onChange.listen((event) async {
      final files = input.files;
      if (files!.isEmpty) return;

      final file = files[0];
      setState(() {
        _image = file;
      });
    });

    input.click();
  }

  Widget _buildTextField(TextEditingController controller, String label, String hintText,
      {TextInputType keyboardType = TextInputType.text, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          if (isNumber && double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMapField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Map<String, String> _parseMapFromText(String text) {
    final map = <String, String>{};
    final lines = text.split('\n');
    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        map[parts[0].trim()] = parts[1].trim();
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(104, 43, 11, 11),
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Food Item' : 'Add New Food Item'),
        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Title', 'Enter food title'),
              _buildTextField(_priceController, 'Price', 'Enter food price',
                  keyboardType: TextInputType.number, isNumber: true),
              _buildTextField(_descriptionController, 'Description', 'Enter food description'),
              _buildMapField(_ingredientsController, 'Ingredients'),
              _buildMapField(_nutritionController, 'Nutrition Facts'),
              _buildTextField(_deliveryDetailsController, 'Delivery Details', 'Enter delivery details'),
              _buildTextField(_ratingController, 'Rating', 'Enter food rating',
                  keyboardType: TextInputType.number, isNumber: true),
              _buildTextField(_reviewController, 'Reviews', 'Enter food reviews'),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick an image'),
                ),
              ),
              _buildImageDisplay(),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveFoodItem,
                      child: Text(widget.isEdit ? 'Save Changes' : 'Add Food Item'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
