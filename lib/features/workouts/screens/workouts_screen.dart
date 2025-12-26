import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';
import '../widgets/workout_card.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workouts = [
      WorkoutModel(
        id: '1',
        name: 'Full Body Workout',
        duration: '45 min',
        calories: '350 kcal',
        difficulty: 'Intermediate',
        image: '💪',
      ),
      WorkoutModel(
        id: '2',
        name: 'Cardio Blast',
        duration: '30 min',
        calories: '280 kcal',
        difficulty: 'Beginner',
        image: '🏃',
      ),
      WorkoutModel(
        id: '3',
        name: 'Strength Training',
        duration: '60 min',
        calories: '420 kcal',
        difficulty: 'Advanced',
        image: '🏋️',
      ),
      WorkoutModel(
        id: '4',
        name: 'Yoga Flow',
        duration: '40 min',
        calories: '180 kcal',
        difficulty: 'Beginner',
        image: '🧘',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workouts',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text('Choose your workout plan',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    return WorkoutCard(
                      workout: workouts[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailScreen(
                              workout: workouts[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
