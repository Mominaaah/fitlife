import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HealthDataScreen extends StatelessWidget {
  const HealthDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Health Data'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthCard(
                context,
                'Heart Rate',
                '72 bpm',
                'Resting',
                Icons.favorite,
                AppColors.error,
                'Normal',
              ),
              const SizedBox(height: 16),
              _buildHealthCard(
                context,
                'Blood Pressure',
                '120/80',
                'mmHg',
                Icons.bloodtype,
                AppColors.primaryOrange,
                'Healthy',
              ),
              const SizedBox(height: 16),
              _buildHealthCard(
                context,
                'Body Mass Index',
                '23.1',
                'BMI',
                Icons.monitor_weight,
                AppColors.success,
                'Normal Weight',
              ),
              const SizedBox(height: 16),
              _buildHealthCard(
                context,
                'Sleep Quality',
                '85%',
                'Score',
                Icons.bedtime,
                AppColors.secondaryPurple,
                'Good',
              ),
              const SizedBox(height: 16),
              _buildHealthCard(
                context,
                'Hydration Level',
                '2.1L',
                'Today',
                Icons.water_drop,
                AppColors.accentBlue,
                'On Track',
              ),
              const SizedBox(height: 16),
              _buildHealthCard(
                context,
                'Stress Level',
                'Low',
                'Current',
                Icons.psychology,
                AppColors.success,
                'Relaxed',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String status,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(unit,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
