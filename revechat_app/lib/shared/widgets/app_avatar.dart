import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final ChannelType? channel;
  final bool showOnline;

  const AppAvatar({
    super.key,
    required this.name,
    this.radius = 24,
    this.channel,
    this.showOnline = false,
  });

  Color _channelColor() {
    switch (channel) {
      case ChannelType.whatsApp:
        return AppColors.whatsApp;
      case ChannelType.messenger:
        return AppColors.messenger;
      case ChannelType.instagram:
        return AppColors.instagram;
      case ChannelType.livechat:
        return AppColors.primary;
      case null:
        return AppColors.primary;
    }
  }

  IconData _channelIcon() {
    switch (channel) {
      case ChannelType.whatsApp:
        return Icons.chat;
      case ChannelType.messenger:
        return Icons.messenger_outline;
      case ChannelType.instagram:
        return Icons.camera_alt_outlined;
      case ChannelType.livechat:
        return Icons.language;
      case null:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: _channelColor().withOpacity(0.15),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              color: _channelColor(),
              fontWeight: FontWeight.bold,
              fontSize: radius * 0.8,
            ),
          ),
        ),
        if (channel != null)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _channelColor(),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(
                _channelIcon(),
                size: radius * 0.45,
                color: Colors.white,
              ),
            ),
          ),
        if (showOnline)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
