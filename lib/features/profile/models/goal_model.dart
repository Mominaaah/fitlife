class GoalModel {
  final String id;
  final String userId;
  final String goalType; // weight_loss, muscle_gain, maintain
  final double targetWeight;
  final double currentWeight;
  final int targetCalories;
  final int targetSteps;
  final int targetWorkoutsPerWeek;
  final DateTime startDate;
  final DateTime? targetDate;
  final bool isActive;
  final DateTime createdAt;

  GoalModel({
    required this.id,
    required this.userId,
    required this.goalType,
    required this.targetWeight,
    required this.currentWeight,
    this.targetCalories = 2000,
    this.targetSteps = 10000,
    this.targetWorkoutsPerWeek = 3,
    required this.startDate,
    this.targetDate,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'goalType': goalType,
      'targetWeight': targetWeight,
      'currentWeight': currentWeight,
      'targetCalories': targetCalories,
      'targetSteps': targetSteps,
      'targetWorkoutsPerWeek': targetWorkoutsPerWeek,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      goalType: map['goalType'] ?? '',
      targetWeight: (map['targetWeight'] ?? 0).toDouble(),
      currentWeight: (map['currentWeight'] ?? 0).toDouble(),
      targetCalories: map['targetCalories'] ?? 2000,
      targetSteps: map['targetSteps'] ?? 10000,
      targetWorkoutsPerWeek: map['targetWorkoutsPerWeek'] ?? 3,
      startDate: DateTime.parse(map['startDate']),
      targetDate:
          map['targetDate'] != null ? DateTime.parse(map['targetDate']) : null,
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Calculate progress percentage
  double getProgressPercentage() {
    final totalToLose = (currentWeight - targetWeight).abs();
    if (totalToLose == 0) return 100.0;

    final currentProgress = (currentWeight - targetWeight).abs();
    return (currentProgress / totalToLose * 100).clamp(0.0, 100.0);
  }
}
