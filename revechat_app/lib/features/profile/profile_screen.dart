import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: const Text(
                    'N',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentAgent.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentAgent.role,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: AppColors.online, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text('Online', style: TextStyle(fontSize: 12, color: AppColors.online)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Performance card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today\'s Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_outline,
                        value: '${currentAgent.resolvedToday}',
                        label: 'Resolved',
                        color: AppColors.online,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.timer_outlined,
                        value: '${currentAgent.avgResponseTime.inMinutes}m ${currentAgent.avgResponseTime.inSeconds % 60}s',
                        label: 'Avg Response',
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.star_outline,
                        value: '4.8',
                        label: 'Rating',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Settings
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Available for Chat', style: TextStyle(fontSize: 15)),
                  subtitle: Text('Receive new conversations', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                  secondary: const Icon(Icons.headset_mic_outlined),
                ),
                const Divider(height: 0, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('Push Notifications', style: TextStyle(fontSize: 15)),
                  subtitle: Text('Get notified for new messages', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                  secondary: const Icon(Icons.notifications_outlined),
                ),
                const Divider(height: 0, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('Sound Alerts', style: TextStyle(fontSize: 15)),
                  subtitle: Text('Play sound for new messages', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: false,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                  secondary: const Icon(Icons.volume_up_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language', style: TextStyle(fontSize: 15)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('English', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: AppColors.textCaption),
                    ],
                  ),
                  onTap: () {},
                ),
                const Divider(height: 0, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support', style: TextStyle(fontSize: 15)),
                  trailing: Icon(Icons.chevron_right, color: AppColors.textCaption),
                  onTap: () {},
                ),
                const Divider(height: 0, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.needsHuman),
                  title: Text('Log Out', style: TextStyle(fontSize: 15, color: AppColors.needsHuman)),
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'ReveChat v2.4.0',
              style: TextStyle(fontSize: 12, color: AppColors.textCaption),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
