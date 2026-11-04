import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';
import 'package:revechat_app/features/chat/widgets/image_bubble.dart';
import 'package:intl/intl.dart';

class AiMessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onImageTap;

  const AiMessageBubble({super.key, required this.message, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.aiBubble,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'AI Sara',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (message.aiConfidence != null) ...[
                const SizedBox(width: 8),
                Text(
                  '${(message.aiConfidence! * 100).toInt()}% confident',
                  style: TextStyle(
                    fontSize: 10,
                    color: message.aiConfidence! >= 0.85
                        ? AppColors.online
                        : (message.aiConfidence! >= 0.75
                            ? Colors.orange
                            : AppColors.needsHuman),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColors.aiBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: _buildContent(),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(fontSize: 10, color: AppColors.textCaption),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.image:
        return ImageBubble(imageUrl: message.imageUrl!, onTap: onImageTap);
      case MessageType.imageWithCaption:
        return ImageBubble(
          imageUrl: message.imageUrl!,
          caption: message.caption ?? message.text,
          captionColor: AppColors.textPrimary,
          onTap: onImageTap,
        );
      case MessageType.productCard:
      case MessageType.orderCard:
      case MessageType.text:
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            message.text ?? '',
            style: TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.4),
          ),
        );
    }
  }
}
