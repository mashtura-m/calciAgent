import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';

class QuickReplies extends StatelessWidget {
  final ValueChanged<String> onReplySelected;

  const QuickReplies({super.key, required this.onReplySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: quickReplies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              quickReplies[index],
              style: TextStyle(fontSize: 12, color: AppColors.primary),
            ),
            backgroundColor: AppColors.aiBubble,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
            ),
            onPressed: () => onReplySelected(quickReplies[index]),
          );
        },
      ),
    );
  }
}
