import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';

class HandoverBanner extends StatelessWidget {
  final VoidCallback onTakeOver;

  const HandoverBanner({super.key, required this.onTakeOver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.needsHuman.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.needsHuman.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.needsHuman.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.front_hand, size: 18, color: AppColors.needsHuman),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer needs human help',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.needsHuman,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI confidence is low for this query',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTakeOver,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.needsHuman,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Take Over', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
