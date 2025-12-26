import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Progress'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressCard(
                context,
                'Workouts Completed',
                '45',
                'This Month',
                Icons.fitness_center,
                AppColors.primaryOrange,
                0.75,
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Calories Burned',
                '12,350',
                'This Month',
                Icons.local_fire_department,
                AppColors.error,
                0.85,
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Active Days',
                '22',
                'This Month',
                Icons.calendar_today,
                AppColors.success,
                0.73,
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Total Hours',
                '33.5',
                'Training Time',
                Icons.timer,
                AppColors.secondaryPurple,
                0.68,
              ),
              const SizedBox(height: 24),
              Text('Weekly Activity',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildWeekDay('Mon', 80, AppColors.primaryOrange),
                    _buildWeekDay('Tue', 100, AppColors.success),
                    _buildWeekDay('Wed', 60, AppColors.secondaryPurple),
                    _buildWeekDay('Thu', 90, AppColors.primaryOrange),
                    _buildWeekDay('Fri', 70, AppColors.accentBlue),
                    _buildWeekDay('Sat', 85, AppColors.success),
                    _buildWeekDay('Sun', 95, AppColors.primaryOrange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(value,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(day)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 12,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('${percentage.toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}