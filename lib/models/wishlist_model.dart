
// import 'package:shared_preferences/shared_preferences.dart';

// class WishlistItem {
//   final String title;
//   final String imagePath;
//   final String price;

//   WishlistItem({
//     required this.title,
//     required this.imagePath,
//     required this.price,
//   });

//   // To convert a WishlistItem into a Map object
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'imagePath': imagePath,
//       'price': price,
//     };
//   }

//   // To convert a Map into a WishlistItem object
//   factory WishlistItem.fromMap(Map<String, dynamic> map) {
//     return WishlistItem(
//       title: map['title'],
//       imagePath: map['imagePath'],
//       price: map['price'],
//     );
//   }
// }



// class WishlistModel {
//   static const String _wishlistKey = 'wishlist';

//   // Save the wishlist to SharedPreferences
//   Future<void> saveWishlist(List<WishlistItem> wishlist) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> wishlistJson = wishlist.map((item) => item.toMap().toString()).toList();
//     await prefs.setStringList(_wishlistKey, wishlistJson);
//   }

//   // Load the wishlist from SharedPreferences
//   Future<List<WishlistItem>> loadWishlist() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? wishlistJson = prefs.getStringList(_wishlistKey);
//     if (wishlistJson != null) {
//       return wishlistJson.map((itemJson) {
//         return WishlistItem.fromMap(itemJson as Map<String, dynamic>);
//       }).toList();
//     }
//     return [];
//   }
// }
