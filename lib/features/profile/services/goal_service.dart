
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal_model.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Create new goal
  Future<void> createGoal(GoalModel goal) async {
    if (currentUserId == null) return;

    try {
      // Deactivate previous goals
      await _deactivatePreviousGoals();

      // Create new goal
      await _firestore.collection('goals').doc(goal.id).set(goal.toMap());
      print('✅ Goal created');
    } catch (e) {
      print('❌ Error creating goal: $e');
      rethrow;
    }
  }

  // Get active goal
  Future<GoalModel?> getActiveGoal() async {
    if (currentUserId == null) return null;

    try {
      final querySnapshot = await _firestore
          .collection('goals')
          .where('userId', isEqualTo: currentUserId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return GoalModel.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('❌ Error getting active goal: $e');
      return null;
    }
  }

  // Update goal progress
  Future<void> updateGoalProgress(String goalId, double currentWeight) async {
    try {
      await _firestore.collection('goals').doc(goalId).update({
        'currentWeight': currentWeight,
      });
      print('✅ Goal progress updated');
    } catch (e) {
      print('❌ Error updating goal: $e');
      rethrow;
    }
  }

  // Deactivate goal
  Future<void> deactivateGoal(String goalId) async {
    try {
      await _firestore.collection('goals').doc(goalId).update({
        'isActive': false,
      });
      print('✅ Goal deactivated');
    } catch (e) {
      print('❌ Error deactivating goal: $e');
      rethrow;
    }
  }

  // Private: Deactivate all previous goals
  Future<void> _deactivatePreviousGoals() async {
    if (currentUserId == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('goals')
          .where('userId', isEqualTo: currentUserId)
          .where('isActive', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'isActive': false});
      }
    } catch (e) {
      print('❌ Error deactivating previous goals: $e');
    }
  }
}