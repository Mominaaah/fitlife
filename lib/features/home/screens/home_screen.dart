import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/bar_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTab = 'Today';

  // Dynamic data based on selected tab
  Map<String, dynamic> _getDataForTab() {
    switch (_selectedTab) {
      case 'Today':
        return {
          'heart': '120',
          'steps': '3216',
          'water': '6',
          'sleep': '8:30',
          'calories': '801',
          'training': '1:30',
          'chartHeights': [40.0, 80.0, 60.0, 100.0, 50.0, 30.0, 20.0],
        };
      case 'Week':
        return {
          'heart': '118',
          'steps': '22512',
          'water': '42',
          'sleep': '56:00',
          'calories': '5607',
          'training': '10:30',
          'chartHeights': [50.0, 70.0, 85.0, 95.0, 65.0, 80.0, 90.0],
        };
      case 'Month':
        return {
          'heart': '115',
          'steps': '96480',
          'water': '180',
          'sleep': '240:00',
          'calories': '24030',
          'training': '45:00',
          'chartHeights': [60.0, 75.0, 80.0, 90.0, 85.0, 95.0, 100.0],
        };
      default:
        return {
          'heart': '120',
          'steps': '3216',
          'water': '6',
          'sleep': '8:30',
          'calories': '801',
          'training': '1:30',
          'chartHeights': [40.0, 80.0, 60.0, 100.0, 50.0, 30.0, 20.0],
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
        child: SingleChildScrollView(
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
                        Text('Welcome back, Momina Ramzan!',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                      child: StatCard(
                        icon: Icons.favorite,
                        label: 'Heart',
                        value: data['heart'],
                        unit: 'bpm',
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.directions_walk,
                        label: 'Steps',
                        value: data['steps'],
                        unit: 'steps',
                        color: AppColors.secondaryPurple,
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
                      child: StatCard(
                        icon: Icons.water_drop,
                        label: 'Water',
                        value: data['water'],
                        unit: _selectedTab == 'Today' ? 'cups' : 'total cups',
                        color: AppColors.accentBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.bedtime,
                        label: 'Sleep',
                        value: data['sleep'],
                        unit: 'hours',
                        color: AppColors.secondaryPurple,
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
                        unit: 'hours',
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
    );
  }
}
