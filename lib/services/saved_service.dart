import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surgakicare/services/auth_service.dart';

class SavedService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get the currently authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Singleton instance
  static final SavedService _instance = SavedService._internal();

  factory SavedService() {
    return _instance;
  }

  SavedService._internal();

  Future<void> setSaved(String produkID, bool status) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(getCurrentUser()!.uid!)
          .get();
      var s = snapshot.data()
          as Map<String, dynamic>?; // May be null if user not found
      var saved = s!["wishlists"] as List;

      if (saved.contains(produkID)) {
        if (status) {
          return;
        } else {
          saved.remove(produkID);
        }
      } else {
        if (status) {
          saved.add(produkID);
        } else {
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUser()!.uid)
          .update({'wishlists': saved});
    } catch (e) {
      print("Error getting user info from Firestore: $e");
      return null;
    }
  }
}
