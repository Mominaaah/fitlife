import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Privacy & Security'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildPrivacyOption(
              context,
              'Change Password',
              'Update your account password',
              Icons.lock_outline,
              () {},
            ),
            _buildPrivacyOption(
              context,
              'Two-Factor Authentication',
              'Add an extra layer of security',
              Icons.security,
              () {},
            ),
            _buildPrivacyOption(
              context,
              'Privacy Settings',
              'Control who can see your data',
              Icons.visibility_outlined,
              () {},
            ),
            _buildPrivacyOption(
              context,
              'Data & Storage',
              'Manage your stored data',
              Icons.storage,
              () {},
            ),
            _buildPrivacyOption(
              context,
              'Account Activity',
              'View your recent activity',
              Icons.history,
              () {},
            ),
            _buildPrivacyOption(
              context,
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_outline,
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Are you sure you want to delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.error),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.darkCardBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: isDestructive
                  ? AppColors.error
                  : AppColors.primaryOrange),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDestructive ? AppColors.error : null,
            )),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: AppColors.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.cardBackground,
      ),
    );
  }
}
