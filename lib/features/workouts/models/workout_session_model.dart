class WorkoutSessionModel {
  final String id;
  final String userId;
  final String workoutId;
  final String workoutName;
  final int duration; // in minutes
  final int caloriesBurned;
  final DateTime completedAt;
  final List<ExerciseSessionModel> exercises;

  WorkoutSessionModel({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.workoutName,
    required this.duration,
    required this.caloriesBurned,
    required this.completedAt,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'completedAt': completedAt.toIso8601String(),
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutSessionModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      workoutId: map['workoutId'] ?? '',
      workoutName: map['workoutName'] ?? '',
      duration: map['duration'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      completedAt: DateTime.parse(map['completedAt']),
      exercises: (map['exercises'] as List?)
              ?.map((e) => ExerciseSessionModel.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class ExerciseSessionModel {
  final String name;
  final int setsCompleted;
  final int repsCompleted;

  ExerciseSessionModel({
    required this.name,
    required this.setsCompleted,
    required this.repsCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'setsCompleted': setsCompleted,
      'repsCompleted': repsCompleted,
    };
  }

  factory ExerciseSessionModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSessionModel(
      name: map['name'] ?? '',
      setsCompleted: map['setsCompleted'] ?? 0,
      repsCompleted: map['repsCompleted'] ?? 0,
    );
  }
}
