import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../models/workout_session_model.dart';
import '../services/workout_service.dart';
import '../widgets/exercise_card.dart';
import '../widgets/info_chip.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({Key? key, required this.workout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercises = [
      ExerciseModel(
        id: '1',
        name: 'Push-ups',
        sets: '3',
        reps: '15',
        rest: '60s',
      ),
      ExerciseModel(
        id: '2',
        name: 'Squats',
        sets: '4',
        reps: '20',
        rest: '45s',
      ),
      ExerciseModel(
        id: '3',
        name: 'Plank',
        sets: '3',
        reps: '60s',
        rest: '30s',
      ),
      ExerciseModel(
        id: '4',
        name: 'Lunges',
        sets: '3',
        reps: '12',
        rest: '45s',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.3),
                    AppColors.secondaryPurple.withOpacity(0.3)
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(workout.image,
                        style: const TextStyle(fontSize: 100)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        InfoChip(
                            icon: Icons.access_time, label: workout.duration),
                        const SizedBox(width: 12),
                        InfoChip(
                            icon: Icons.local_fire_department,
                            label: workout.calories),
                        const SizedBox(width: 12),
                        InfoChip(
                            icon: Icons.signal_cellular_alt,
                            label: workout.difficulty),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Exercises',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    ...exercises
                        .map((exercise) => ExerciseCard(exercise: exercise))
                        .toList(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _completeWorkout(context, exercises),
                        child: const Text(
                          'Complete Workout',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save completed workout to Firebase
  void _completeWorkout(BuildContext context, List<ExerciseModel> exercises) async {
    final workoutService = WorkoutService();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to save workouts'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );

      // Create workout session
      final session = WorkoutSessionModel(
        id: '${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}',
        userId: currentUser.uid,
        workoutId: workout.id,
        workoutName: workout.name,
        duration: int.parse(workout.duration.split(' ')[0]), // Extract number from "45 min"
        caloriesBurned: int.parse(workout.calories.split(' ')[0]), // Extract number from "350 kcal"
        completedAt: DateTime.now(),
        exercises: exercises.map((e) => ExerciseSessionModel(
          name: e.name,
          setsCompleted: int.parse(e.sets),
          repsCompleted: int.tryParse(e.reps) ?? 0,
        )).toList(),
      );

      // Save to Firebase
      await workoutService.saveWorkoutSession(session);

      // Close loading
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout completed and saved!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Go back
      Navigator.pop(context);
    } catch (e) {
      // Close loading
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
