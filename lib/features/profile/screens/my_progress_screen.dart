
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../workouts/services/workout_service.dart';
import '../../workouts/models/workout_session_model.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({Key? key}) : super(key: key);

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  final _workoutService = WorkoutService();
  List<WorkoutSessionModel> _workouts = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String _selectedPeriod = 'Month';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final workouts = await _workoutService.getUserWorkouts(limit: 50);
    final stats = await _workoutService.getUserStats();

    if (mounted) {
      setState(() {
        _workouts = workouts;
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  Map<String, int> _getWeeklyData() {
    final now = DateTime.now();
    final weekData = <String, int>{
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    final weekAgo = now.subtract(const Duration(days: 7));
    final weekWorkouts = _workouts.where((w) => w.completedAt.isAfter(weekAgo)).toList();

    for (var workout in weekWorkouts) {
      final dayName = _getDayName(workout.completedAt.weekday);
      weekData[dayName] = (weekData[dayName] ?? 0) + workout.duration;
    }

    return weekData;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  int _getTotalCalories() {
    final now = DateTime.now();
    DateTime startDate;

    if (_selectedPeriod == 'Week') {
      startDate = now.subtract(const Duration(days: 7));
    } else {
      startDate = now.subtract(const Duration(days: 30));
    }

    return _workouts
        .where((w) => w.completedAt.isAfter(startDate))
        .fold<int>(0, (sum, w) => sum + w.caloriesBurned);
  }

  int _getTotalMinutes() {
    final now = DateTime.now();
    DateTime startDate;

    if (_selectedPeriod == 'Week') {
      startDate = now.subtract(const Duration(days: 7));
    } else {
      startDate = now.subtract(const Duration(days: 30));
    }

    return _workouts
        .where((w) => w.completedAt.isAfter(startDate))
        .fold<int>(0, (sum, w) => sum + w.duration);
  }

  int _getWorkoutCount() {
    final now = DateTime.now();
    DateTime startDate;

    if (_selectedPeriod == 'Week') {
      startDate = now.subtract(const Duration(days: 7));
    } else {
      startDate = now.subtract(const Duration(days: 30));
    }

    return _workouts.where((w) => w.completedAt.isAfter(startDate)).length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('My Progress'),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    final weeklyData = _getWeeklyData();
    final totalCalories = _getTotalCalories();
    final totalMinutes = _getTotalMinutes();
    final workoutCount = _getWorkoutCount();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Progress'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primaryOrange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildPeriodButton('Week'),
                  const SizedBox(width: 12),
                  _buildPeriodButton('Month'),
                ],
              ),
              const SizedBox(height: 24),
              _buildProgressCard(
                context,
                'Workouts Completed',
                workoutCount.toString(),
                'This $_selectedPeriod',
                Icons.fitness_center,
                AppColors.primaryOrange,
                workoutCount / (_selectedPeriod == 'Week' ? 7 : 30),
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Calories Burned',
                totalCalories.toString(),
                'This $_selectedPeriod',
                Icons.local_fire_department,
                AppColors.error,
                totalCalories / (_selectedPeriod == 'Week' ? 2000 : 8000),
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Active Minutes',
                totalMinutes.toString(),
                'This $_selectedPeriod',
                Icons.timer,
                AppColors.secondaryPurple,
                totalMinutes / (_selectedPeriod == 'Week' ? 300 : 1200),
              ),
              const SizedBox(height: 16),
              _buildProgressCard(
                context,
                'Total Workouts',
                (_stats?['totalWorkouts'] ?? 0).toString(),
                'All Time',
                Icons.calendar_today,
                AppColors.success,
                1.0,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: weeklyData.entries
                      .map((entry) => _buildWeekDay(
                            entry.key,
                            entry.value.toDouble(),
                            _getColorForDay(entry.key),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text('Recent Workouts',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              if (_workouts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No workouts yet',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete a workout to see your progress',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...(_workouts.take(5).map((workout) => _buildWorkoutCard(workout))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
                    Text(title, style: Theme.of(context).textTheme.bodyMedium),
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
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day, double minutes, Color color) {
    final percentage = minutes > 0 ? (minutes / 60 * 100).clamp(0.0, 100.0) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
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
          SizedBox(
            width: 60,
            child: Text(
              minutes > 0 ? '${minutes.toInt()} min' : '0 min',
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutSessionModel workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.primaryOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.workoutName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.duration} min • ${workout.caloriesBurned} kcal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(workout.completedAt),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(workout.completedAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorForDay(String day) {
    switch (day) {
      case 'Mon':
        return AppColors.primaryOrange;
      case 'Tue':
        return AppColors.success;
      case 'Wed':
        return AppColors.secondaryPurple;
      case 'Thu':
        return AppColors.primaryOrange;
      case 'Fri':
        return AppColors.accentBlue;
      case 'Sat':
        return AppColors.success;
      case 'Sun':
        return AppColors.primaryOrange;
      default:
        return AppColors.primaryOrange;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}