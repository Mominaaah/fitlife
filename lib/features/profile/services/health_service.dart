import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_data_model.dart';

class HealthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Save or update health data for today
  Future<void> saveHealthData(HealthDataModel data) async {
    if (currentUserId == null) return;

    try {
      await _firestore.collection('health_data').doc(data.id).set(data.toMap());
      print('✅ Health data saved');
    } catch (e) {
      print('❌ Error saving health data: $e');
      rethrow;
    }
  }

  // Get health data for specific date
  Future<HealthDataModel?> getHealthDataForDate(DateTime date) async {
    if (currentUserId == null) return null;

    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final id = '${currentUserId}_$dateStr';
      
      final doc = await _firestore.collection('health_data').doc(id).get();

      if (doc.exists) {
        return HealthDataModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Error getting health data: $e');
      return null;
    }
  }

  // Update specific health metric - FIXED VERSION
  Future<void> updateHealthMetric(
    DateTime date,
    String field,
    dynamic value,
  ) async {
    if (currentUserId == null) return;

    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final id = '${currentUserId}_$dateStr';

      await _firestore.collection('health_data').doc(id).set({
        'id': id,
        'userId': currentUserId,
        'date': dateStr,
        field: value,
      }, SetOptions(merge: true));

      print('✅ Health metric updated: $field = $value');
    } catch (e) {
      print('❌ Error updating health metric: $e');
      rethrow;
    }
  }

  // Get today's health data
  Future<HealthDataModel?> getTodayHealthData() async {
    return getHealthDataForDate(DateTime.now());
  }

  // Get health data for date range
  Future<List<HealthDataModel>> getHealthDataByRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (currentUserId == null) return [];

    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final querySnapshot = await _firestore
          .collection('health_data')
          .where('userId', isEqualTo: currentUserId)
          .where('date', isGreaterThanOrEqualTo: startStr)
          .where('date', isLessThanOrEqualTo: endStr)
          .get();

      return querySnapshot.docs
          .map((doc) => HealthDataModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting health data range: $e');
      return [];
    }
  }
}