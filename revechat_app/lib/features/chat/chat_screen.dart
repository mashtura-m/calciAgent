import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';
import 'package:revechat_app/features/chat/providers/chat_provider.dart';
import 'package:revechat_app/features/chat/widgets/message_bubble.dart';
import 'package:revechat_app/features/chat/widgets/handover_banner.dart';
import 'package:revechat_app/features/chat/widgets/ai_draft_card.dart';
import 'package:revechat_app/features/chat/widgets/quick_replies.dart';
import 'package:revechat_app/features/chat/widgets/chat_input_bar.dart';
import 'package:revechat_app/shared/widgets/app_avatar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  bool _showQuickReplies = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _openFullscreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(conversationsProvider);
    final conversation = conversations.where((c) => c.id == widget.conversationId).firstOrNull;

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('Conversation not found')),
      );
    }

    final draft = mockAiDrafts.where((d) => d.conversationId == conversation.id).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(
              name: conversation.customerName,
              channel: conversation.channel,
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.customerName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.online,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(fontSize: 12, color: AppColors.online),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: conversation.aiEnabled
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: conversation.aiEnabled ? AppColors.primary : AppColors.textCaption,
                ),
                const SizedBox(width: 4),
                Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: conversation.aiEnabled ? AppColors.primary : AppColors.textCaption,
                  ),
                ),
                SizedBox(
                  height: 24,
                  width: 36,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(
                      value: conversation.aiEnabled,
                      onChanged: (value) {
                        ref.read(conversationsProvider.notifier).toggleAi(conversation.id, value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (conversation.needsHuman)
            HandoverBanner(
              onTakeOver: () {
                ref.read(conversationsProvider.notifier).takeOver(conversation.id);
              },
            ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: conversation.messages.length,
              itemBuilder: (context, index) {
                final message = conversation.messages[conversation.messages.length - 1 - index];
                return MessageBubble(
                  message: message,
                  onImageTap: message.imageUrl != null
                      ? () => _openFullscreenImage(message.imageUrl!)
                      : null,
                );
              },
            ),
          ),

          if (draft != null && conversation.aiEnabled)
            AiDraftCard(
              draftText: draft.draftText,
              confidence: draft.confidence,
              onSend: () {
                ref.read(conversationsProvider.notifier)
                    .approveAiDraft(conversation.id, draft.draftText);
                _scrollToBottom();
              },
              onEdit: () {},
              onReject: () {},
            ),

          if (!conversation.aiEnabled && _showQuickReplies)
            QuickReplies(
              onReplySelected: (reply) {
                ref.read(conversationsProvider.notifier)
                    .sendMessage(conversation.id, reply);
                setState(() => _showQuickReplies = false);
                _scrollToBottom();
              },
            ),

          ChatInputBar(
            aiEnabled: conversation.aiEnabled,
            agentName: 'Nusrat',
            onAttachPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _AttachmentSheet(),
              );
            },
            onSendPressed: (text) {
              ref.read(conversationsProvider.notifier)
                  .sendMessage(conversation.id, text);
              _scrollToBottom();
            },
            onMicPressed: () {},
            onDisableAi: () {
              ref.read(conversationsProvider.notifier).toggleAi(conversation.id, false);
            },
          ),
        ],
      ),
    );
  }
}

class _AttachmentSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachOption(icon: Icons.camera_alt, label: 'Camera', color: AppColors.primary),
              _AttachOption(icon: Icons.photo_library, label: 'Gallery', color: AppColors.online),
              _AttachOption(icon: Icons.shopping_bag, label: 'Product', color: Colors.orange),
              _AttachOption(icon: Icons.receipt_long, label: 'Order', color: AppColors.messenger),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
