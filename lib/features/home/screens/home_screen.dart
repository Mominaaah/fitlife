import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/bar_chart.dart';
import '../../workouts/services/workout_service.dart';
import '../../profile/services/health_service.dart';
import '../../profile/models/health_data_model.dart';
import '../widgets/update_health_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTab = 'Today';
  final _workoutService = WorkoutService();
  final _healthService = HealthService();
  Map<String, dynamic>? _stats;
  HealthDataModel? _todayHealth;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Load workout stats
    final stats = await _workoutService.getUserStats();
    
    // Load today's health data
    final healthData = await _healthService.getTodayHealthData();
    
    if (mounted) {
      setState(() {
        _stats = stats;
        _todayHealth = healthData;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getDataForTab() {
    final workoutStats = _stats ?? {
      'totalWorkouts': 0,
      'totalCalories': 0,
      'totalMinutes': 0,
    };

    final steps = _todayHealth?.steps ?? 0;
    final water = (_todayHealth?.waterIntake ?? 0).toInt();
    final sleepMinutes = _todayHealth?.sleepMinutes ?? 0;
    final sleepHours = '${(sleepMinutes / 60).floor()}:${(sleepMinutes % 60).toString().padLeft(2, '0')}';
    final heartRate = _todayHealth?.heartRate ?? 0;

    switch (_selectedTab) {
      case 'Today':
        return {
          'heart': heartRate > 0 ? heartRate.toString() : '0',
          'steps': steps.toString(),
          'water': water.toString(),
          'sleep': sleepHours,
          'calories': workoutStats['totalCalories'].toString(),
          'training': workoutStats['totalMinutes'].toString(),
          'chartHeights': [40.0, 80.0, 60.0, 100.0, 50.0, 30.0, 20.0],
        };
      case 'Week':
        return {
          'heart': heartRate > 0 ? heartRate.toString() : '0',
          'steps': (steps * 7).toString(),
          'water': (water * 7).toString(),
          'sleep': sleepHours,
          'calories': workoutStats['totalCalories'].toString(),
          'training': workoutStats['totalMinutes'].toString(),
          'chartHeights': [50.0, 70.0, 85.0, 95.0, 65.0, 80.0, 90.0],
        };
      case 'Month':
        return {
          'heart': heartRate > 0 ? heartRate.toString() : '0',
          'steps': (steps * 30).toString(),
          'water': (water * 30).toString(),
          'sleep': sleepHours,
          'calories': workoutStats['totalCalories'].toString(),
          'training': workoutStats['totalMinutes'].toString(),
          'chartHeights': [60.0, 75.0, 80.0, 90.0, 85.0, 95.0, 100.0],
        };
      default:
        return {
          'heart': '0',
          'steps': '0',
          'water': '0',
          'sleep': '0:00',
          'calories': '0',
          'training': '0',
          'chartHeights': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getDataForTab();
    final chartHeights = data['chartHeights'] as List<double>;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryOrange),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                color: AppColors.primaryOrange,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dashboard',
                                    style: Theme.of(context).textTheme.headlineLarge),
                                const SizedBox(height: 4),
                                Text('Welcome back!',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_outlined, size: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_stats != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryOrange.withOpacity(0.1),
                                  AppColors.secondaryPurple.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Total Workouts: ${_stats!['totalWorkouts']}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This Week: ${_stats!['thisWeekWorkouts']} workouts',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        Row(
                          children: [
                            TabButton(
                              label: 'Today',
                              isSelected: _selectedTab == 'Today',
                              onTap: () => setState(() => _selectedTab = 'Today'),
                            ),
                            const SizedBox(width: 12),
                            TabButton(
                              label: 'Week',
                              isSelected: _selectedTab == 'Week',
                              onTap: () => setState(() => _selectedTab = 'Week'),
                            ),
                            const SizedBox(width: 12),
                            TabButton(
                              label: 'Month',
                              isSelected: _selectedTab == 'Month',
                              onTap: () => setState(() => _selectedTab = 'Month'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showUpdateDialog('heart'),
                                child: StatCard(
                                  icon: Icons.favorite,
                                  label: 'Heart',
                                  value: data['heart'],
                                  unit: 'bpm',
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showUpdateDialog('steps'),
                                child: StatCard(
                                  icon: Icons.directions_walk,
                                  label: 'Steps',
                                  value: data['steps'],
                                  unit: 'steps',
                                  color: AppColors.secondaryPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 180,
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
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Activity',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                  Text(_selectedTab,
                                      style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: chartHeights
                                      .asMap()
                                      .entries
                                      .map((entry) => BarChart(
                                            height: entry.value,
                                            color: AppColors.primaryOrange
                                                .withOpacity(0.3 + (entry.key * 0.1)),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showUpdateDialog('water'),
                                child: StatCard(
                                  icon: Icons.water_drop,
                                  label: 'Water',
                                  value: data['water'],
                                  unit: 'cups',
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showUpdateDialog('sleep'),
                                child: StatCard(
                                  icon: Icons.bedtime,
                                  label: 'Sleep',
                                  value: data['sleep'],
                                  unit: 'hours',
                                  color: AppColors.secondaryPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: Icons.local_fire_department,
                                label: 'Calories',
                                value: data['calories'],
                                unit: 'kcal',
                                color: AppColors.primaryOrange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatCard(
                                icon: Icons.fitness_center,
                                label: 'Training',
                                value: data['training'],
                                unit: 'mins',
                                color: AppColors.secondaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _showUpdateDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => UpdateHealthDialog(
        type: type,
        currentValue: _getCurrentValue(type),
        onUpdate: (value) async {
          await _updateHealthData(type, value);
        },
      ),
    );
  }

  String _getCurrentValue(String type) {
    if (_todayHealth == null) return '0';
    
    switch (type) {
      case 'heart':
        return _todayHealth!.heartRate.toString();
      case 'steps':
        return _todayHealth!.steps.toString();
      case 'water':
        return _todayHealth!.waterIntake.toString();
      case 'sleep':
        return _todayHealth!.sleepMinutes.toString();
      default:
        return '0';
    }
  }

  Future<void> _updateHealthData(String type, String value) async {
    try {
      final numValue = double.tryParse(value) ?? 0;
      
      switch (type) {
        case 'heart':
          await _healthService.updateHealthMetric(DateTime.now(), 'heartRate', numValue.toInt());
          break;
        case 'steps':
          await _healthService.updateHealthMetric(DateTime.now(), 'steps', numValue.toInt());
          break;
        case 'water':
          await _healthService.updateHealthMetric(DateTime.now(), 'waterIntake', numValue);
          break;
        case 'sleep':
          await _healthService.updateHealthMetric(DateTime.now(), 'sleepMinutes', numValue.toInt());
          break;
      }

      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health data updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
