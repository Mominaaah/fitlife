import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart'; 
import '../../../core/theme/app_theme.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/profile_menu_item.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'my_progress_screen.dart';
import 'health_data_screen.dart';
import 'notifications_screen.dart';
import 'privacy_security_screen.dart';
import 'help_support_screen.dart';
import '../../auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  UserModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final userData = await _userService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile',
                      style: Theme.of(context).textTheme.headlineLarge),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryOrange.withOpacity(0.3),
                          AppColors.secondaryPurple.withOpacity(0.3)
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.person,
                          size: 60, color: AppColors.primaryOrange),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(_userData?.name ?? 'User',
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(_userData?.email ?? 'email@example.com',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(
                      label: 'Weight',
                      value: _userData?.weight ?? '75',
                      unit: 'kg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ProfileStatCard(
                      label: 'Height',
                      value: _userData?.height ?? '180',
                      unit: 'cm',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ProfileStatCard(
                      label: 'Age',
                      value: _userData?.age ?? '28',
                      unit: 'yrs',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ProfileMenuItem(
                icon: Icons.person_outline,
                label: 'Edit Profile',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()),
                  );
                  // Reload data after editing
                  _loadUserData();
                },
              ),
              ProfileMenuItem(
                icon: Icons.trending_up,
                label: 'My Progress',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyProgressScreen()),
                  );
                },
              ),
              ProfileMenuItem(
                icon: Icons.favorite_outline,
                label: 'Health Data',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HealthDataScreen()),
                  );
                },
              ),
              ProfileMenuItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              ProfileMenuItem(
                icon: Icons.security,
                label: 'Privacy & Security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacySecurityScreen()),
                  );
                },
              ),
              ProfileMenuItem(
                icon: Icons.help_outline,
                label: 'Help & Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        color: AppColors.error,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}