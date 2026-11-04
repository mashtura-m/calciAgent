import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  final bool aiEnabled;
  final String agentName;
  final VoidCallback onAttachPressed;
  final ValueChanged<String> onSendPressed;
  final VoidCallback onMicPressed;
  final VoidCallback onDisableAi;

  const ChatInputBar({
    super.key,
    required this.aiEnabled,
    required this.agentName,
    required this.onAttachPressed,
    required this.onSendPressed,
    required this.onMicPressed,
    required this.onDisableAi,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.aiEnabled) {
      return Container(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.aiBubble,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'AI is handling this chat',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: widget.onDisableAi,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                  ),
                ),
                child: const Text('Turn OFF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 8, right: 8, top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.textSecondary,
            onPressed: widget.onAttachPressed,
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) {
                  final hasText = text.trim().isNotEmpty;
                  if (hasText != _hasText) setState(() => _hasText = hasText);
                },
                decoration: InputDecoration(
                  hintText: 'Reply as ${widget.agentName}...',
                  hintStyle: TextStyle(color: AppColors.textCaption),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  fillColor: Colors.transparent,
                  filled: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _hasText
              ? IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      widget.onSendPressed(text);
                      _controller.clear();
                      setState(() => _hasText = false);
                    }
                  },
                )
              : IconButton(
                  icon: Icon(Icons.mic, color: AppColors.textSecondary),
                  onPressed: widget.onMicPressed,
                ),
        ],
      ),
    );
  }
}
