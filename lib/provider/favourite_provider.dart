import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;
  FavouriteProvider() {
    loadFavorites();
  }
  //toggle favorite state
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId); // renove from favorite
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId); // add to favorite
    }
    notifyListeners();
  }

  // check if  a product is favourited
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  // add favorites to firestore
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).set({
        'isFavorite':
            true, // Create the userFavorite collection and add items as favorites in firestore
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Remove favorite from firestore
  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Load favorites from firestore ( store favorite or not)

  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // static mehod to access the provider from any context
  static FavouriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouriteProvider>(context, listen: listen);
  }
}
