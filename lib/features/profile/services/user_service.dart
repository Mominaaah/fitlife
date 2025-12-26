import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Create user document in Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(userModel.toMap());
      print('✅ User created in Firestore');
    } catch (e) {
      print('❌ Error creating user: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    if (currentUserId == null) return null;
    return getUserData(currentUserId!);
  }

  // Update user profile - INCLUDING EMAIL
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? weight,
    String? height,
    String? age,
    String? fitnessGoal,
  }) async {
    if (currentUserId == null) return;

    try {
      // Check if document exists
      final docRef = _firestore.collection('users').doc(currentUserId);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create document if it doesn't exist
        final user = _auth.currentUser;
        await createUser(
          uid: currentUserId!,
          name: name ?? user?.displayName ?? 'User',
          email: email ?? user?.email ?? '',
        );
      }

      // Update email in Firebase Authentication if changed
      if (email != null && email.isNotEmpty) {
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.email != email) {
          await currentUser.updateEmail(email);
          print('✅ Email updated in Firebase Auth');
        }
      }

      // Update display name in Firebase Authentication if changed
      if (name != null && name.isNotEmpty) {
        await _auth.currentUser?.updateDisplayName(name);
      }

      // Now update Firestore document
      Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (weight != null) updates['weight'] = weight;
      if (height != null) updates['height'] = height;
      if (age != null) updates['age'] = age;
      if (fitnessGoal != null) updates['fitnessGoal'] = fitnessGoal;

      await docRef.update(updates);
      print('✅ User profile updated in Firestore');
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  // Stream user data (real-time updates)
  Stream<UserModel?> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Delete user data
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print('✅ User deleted from Firestore');
    } catch (e) {
      print('❌ Error deleting user: $e');
      rethrow;
    }
  }
}