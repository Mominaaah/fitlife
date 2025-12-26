import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_session_model.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Save completed workout
  Future<void> saveWorkoutSession(WorkoutSessionModel session) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('workouts')
          .doc(session.id)
          .set(session.toMap());
      print('✅ Workout session saved');
    } catch (e) {
      print('❌ Error saving workout: $e');
      rethrow;
    }
  }

  // Get user's workout history
  Future<List<WorkoutSessionModel>> getUserWorkouts({int limit = 30}) async {
    if (currentUserId == null) return [];

    try {
      final querySnapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('completedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => WorkoutSessionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting workouts: $e');
      return [];
    }
  }

  // Get workouts for specific date range
  Future<List<WorkoutSessionModel>> getWorkoutsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (currentUserId == null) return [];

    try {
      final querySnapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: currentUserId)
          .where('completedAt',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('completedAt', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('completedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => WorkoutSessionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting workouts by date: $e');
      return [];
    }
  }

  // Get total stats (for dashboard)
  Future<Map<String, dynamic>> getUserStats() async {
    if (currentUserId == null) {
      return {
        'totalWorkouts': 0,
        'totalCalories': 0,
        'totalMinutes': 0,
        'thisWeekWorkouts': 0,
      };
    }

    try {
      final allWorkouts = await getUserWorkouts(limit: 100);
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final thisWeekWorkouts =
          allWorkouts.where((w) => w.completedAt.isAfter(weekAgo)).toList();

      final totalCalories =
          allWorkouts.fold<int>(0, (sum, w) => sum + w.caloriesBurned);
      final totalMinutes =
          allWorkouts.fold<int>(0, (sum, w) => sum + w.duration);

      return {
        'totalWorkouts': allWorkouts.length,
        'totalCalories': totalCalories,
        'totalMinutes': totalMinutes,
        'thisWeekWorkouts': thisWeekWorkouts.length,
      };
    } catch (e) {
      print('❌ Error getting stats: $e');
      return {
        'totalWorkouts': 0,
        'totalCalories': 0,
        'totalMinutes': 0,
        'thisWeekWorkouts': 0,
      };
    }
  }

  // Delete workout
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _firestore.collection('workouts').doc(workoutId).delete();
      print('✅ Workout deleted');
    } catch (e) {
      print('❌ Error deleting workout: $e');
      rethrow;
    }
  }
}
