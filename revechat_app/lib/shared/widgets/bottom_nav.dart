import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/core/constants/app_colors.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  const BottomNavScaffold({super.key, required this.child});

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/inbox')) return 0;
    if (location.startsWith('/ai')) return 1;
    if (location.startsWith('/contacts')) return 2;
    if (location.startsWith('/orders')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/inbox');
      case 1:
        context.go('/ai');
      case 2:
        context.go('/contacts');
      case 3:
        context.go('/orders');
      case 4:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Badge(
              label: const Text('4'),
              backgroundColor: AppColors.needsHuman,
              child: const Icon(Icons.inbox_outlined),
            ),
            selectedIcon: Badge(
              label: const Text('4'),
              backgroundColor: AppColors.needsHuman,
              child: Icon(Icons.inbox, color: AppColors.primary),
            ),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: AppColors.primary),
            label: 'AI',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people, color: AppColors.primary),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
