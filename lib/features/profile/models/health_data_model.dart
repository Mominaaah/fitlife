class HealthDataModel {
  final String id;
  final String userId;
  final DateTime date;
  final int steps;
  final int heartRate;
  final double waterIntake; // in liters
  final int sleepMinutes;
  final int caloriesConsumed;
  final double weight; // in kg

  HealthDataModel({
    required this.id,
    required this.userId,
    required this.date,
    this.steps = 0,
    this.heartRate = 0,
    this.waterIntake = 0,
    this.sleepMinutes = 0,
    this.caloriesConsumed = 0,
    this.weight = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String().split('T')[0], // Store date only
      'steps': steps,
      'heartRate': heartRate,
      'waterIntake': waterIntake,
      'sleepMinutes': sleepMinutes,
      'caloriesConsumed': caloriesConsumed,
      'weight': weight,
    };
  }

  factory HealthDataModel.fromMap(Map<String, dynamic> map) {
    return HealthDataModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      steps: map['steps'] ?? 0,
      heartRate: map['heartRate'] ?? 0,
      waterIntake: (map['waterIntake'] ?? 0).toDouble(),
      sleepMinutes: map['sleepMinutes'] ?? 0,
      caloriesConsumed: map['caloriesConsumed'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
    );
  }
}
