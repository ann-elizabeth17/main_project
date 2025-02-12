import 'dart:convert';

class WishlistItem {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final Map<String, String> ingredients;
  final Map<String, String> nutrition;
  final bool isAvailable;
  final double rating;
  final int reviews;
  final String deliveryDetails;
  int quantity; // Added quantity field

  WishlistItem({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.nutrition,
    required this.isAvailable,
    required this.rating,
    required this.reviews,
    required this.deliveryDetails,
    this.quantity = 1, // Default quantity is 1
  });

  // Convert WishlistItem to Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'title': title,
      'price': price,
      'description': description,
      'ingredients': ingredients,
      'nutrition': nutrition,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviews': reviews,
      'deliveryDetails': deliveryDetails,
      'quantity': quantity, // Save quantity as well
    };
  }

  // Convert Map to WishlistItem for deserialization
  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      imagePath: map['imagePath'],
      title: map['title'],
      price: map['price'],
      description: map['description'],
      ingredients: Map<String, String>.from(map['ingredients']),
      nutrition: Map<String, String>.from(map['nutrition']),
      isAvailable: map['isAvailable'],
      rating: map['rating'],
      reviews: map['reviews'],
      deliveryDetails: map['deliveryDetails'],
      quantity: map['quantity'] ?? 1, // Handle missing quantity
    );
  }

  // Convert WishlistItem to JSON string
  String toJson() {
    return json.encode(toMap());
  }

  // Convert JSON string to WishlistItem
  factory WishlistItem.fromJson(String jsonStr) {
    return WishlistItem.fromMap(json.decode(jsonStr));
  }
}

