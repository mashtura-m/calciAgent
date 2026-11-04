import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/core/constants/app_colors.dart';

class OrgSelectionScreen extends StatelessWidget {
  const OrgSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Organization'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Organizations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an organization to continue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _OrgCard(
              name: 'ReveChat Fashion Store',
              role: 'Senior Support Agent',
              memberCount: 8,
              isActive: true,
              onTap: () => context.go('/inbox'),
            ),
            const SizedBox(height: 12),
            _OrgCard(
              name: 'ReveChat Electronics',
              role: 'Support Agent',
              memberCount: 15,
              isActive: false,
              onTap: () => context.go('/inbox'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrgCard extends StatelessWidget {
  final String name;
  final String role;
  final int memberCount;
  final bool isActive;
  final VoidCallback onTap;

  const _OrgCard({
    required this.name,
    required this.role,
    required this.memberCount,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$role • $memberCount members',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.online.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: AppColors.online,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textCaption),
            ],
          ),
        ),
      ),
    );
  }
}
