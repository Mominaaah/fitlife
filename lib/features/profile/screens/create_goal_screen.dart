import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../services/goal_service.dart';
import '../models/goal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGoalScreen extends StatefulWidget {
  final GoalModel? existingGoal;

  const CreateGoalScreen({Key? key, this.existingGoal}) : super(key: key);

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalService = GoalService();

  String _selectedGoalType = 'weight_loss';
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _targetCaloriesController = TextEditingController(text: '2000');
  final _targetStepsController = TextEditingController(text: '10000');
  final _targetWorkoutsController = TextEditingController(text: '3');
  DateTime? _targetDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _loadExistingGoal();
    }
  }

  void _loadExistingGoal() {
    final goal = widget.existingGoal!;
    _selectedGoalType = goal.goalType;
    _currentWeightController.text = goal.currentWeight.toString();
    _targetWeightController.text = goal.targetWeight.toString();
    _targetCaloriesController.text = goal.targetCalories.toString();
    _targetStepsController.text = goal.targetSteps.toString();
    _targetWorkoutsController.text = goal.targetWorkoutsPerWeek.toString();
    _targetDate = goal.targetDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.existingGoal == null ? 'Create Goal' : 'Edit Goal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goal Type',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                _buildGoalTypeCard('weight_loss', 'Weight Loss', Icons.trending_down),
                const SizedBox(height: 12),
                _buildGoalTypeCard('muscle_gain', 'Muscle Gain', Icons.fitness_center),
                const SizedBox(height: 12),
                _buildGoalTypeCard('maintain', 'Maintain Weight', Icons.trending_flat),
                const SizedBox(height: 24),
                Text(
                  'Weight Information',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _currentWeightController,
                        label: 'Current Weight (kg)',
                        hint: '75',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _targetWeightController,
                        label: 'Target Weight (kg)',
                        hint: '70',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Daily Targets',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _targetCaloriesController,
                  label: 'Target Calories (kcal)',
                  hint: '2000',
                  icon: Icons.local_fire_department,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _targetStepsController,
                  label: 'Target Steps',
                  hint: '10000',
                  icon: Icons.directions_walk,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _targetWorkoutsController,
                  label: 'Workouts Per Week',
                  hint: '3',
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _selectTargetDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target Date (Optional)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _targetDate == null
                                  ? 'Not set'
                                  : '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const Icon(Icons.calendar_today, color: AppColors.primaryOrange),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveGoal,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.existingGoal == null ? 'Create Goal' : 'Update Goal',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTypeCard(String type, String label, IconData icon) {
    final isSelected = _selectedGoalType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoalType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryOrange : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _targetDate = date);
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final goal = GoalModel(
        id: widget.existingGoal?.id ?? '${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}',
        userId: currentUser.uid,
        goalType: _selectedGoalType,
        currentWeight: double.parse(_currentWeightController.text),
        targetWeight: double.parse(_targetWeightController.text),
        targetCalories: int.parse(_targetCaloriesController.text),
        targetSteps: int.parse(_targetStepsController.text),
        targetWorkoutsPerWeek: int.parse(_targetWorkoutsController.text),
        startDate: widget.existingGoal?.startDate ?? DateTime.now(),
        targetDate: _targetDate,
        createdAt: widget.existingGoal?.createdAt ?? DateTime.now(),
      );

      await _goalService.createGoal(goal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingGoal == null
                ? 'Goal created successfully!'
                : 'Goal updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _targetCaloriesController.dispose();
    _targetStepsController.dispose();
    _targetWorkoutsController.dispose();
    super.dispose();
  }
}