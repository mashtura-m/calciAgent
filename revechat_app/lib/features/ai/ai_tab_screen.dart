import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';
import 'package:revechat_app/features/chat/providers/chat_provider.dart';

class AiTabScreen extends ConsumerWidget {
  const AiTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiGlobal = ref.watch(aiGlobalProvider);
    final conversations = ref.watch(conversationsProvider);
    final aiHandled = conversations.where((c) => c.isAiHandled).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'AI Co-Pilot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Sara',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            aiGlobal ? 'Active & handling chats' : 'Paused',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: aiGlobal,
                      onChanged: (v) => ref.read(aiGlobalProvider.notifier).state = v,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatPill(label: 'Handled', value: '${aiHandled.length}'),
                    const SizedBox(width: 12),
                    _StatPill(label: 'Avg Confidence', value: '91%'),
                    const SizedBox(width: 12),
                    _StatPill(label: 'Saved', value: '4.2h'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Drafts waiting approval
          Row(
            children: [
              const Text(
                'Drafts Waiting Approval',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${mockAiDrafts.length}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...mockAiDrafts.map((draft) => _DraftCard(
            draft: draft,
            onApprove: () {
              ref.read(conversationsProvider.notifier)
                  .approveAiDraft(draft.conversationId, draft.draftText);
            },
            onEdit: () => context.push('/chat/${draft.conversationId}'),
            onView: () => context.push('/chat/${draft.conversationId}'),
          )),

          const SizedBox(height: 24),

          // AI Performance
          const Text(
            'AI Performance Today',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _PerfCard(icon: Icons.chat_bubble_outline, label: 'Resolved', value: '24', color: AppColors.online)),
              const SizedBox(width: 12),
              Expanded(child: _PerfCard(icon: Icons.front_hand, label: 'Handovers', value: '3', color: AppColors.needsHuman)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _PerfCard(icon: Icons.speed, label: 'Avg Response', value: '< 5s', color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _PerfCard(icon: Icons.star_outline, label: 'CSAT', value: '4.6', color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  final AiDraft draft;
  final VoidCallback onApprove;
  final VoidCallback onEdit;
  final VoidCallback onView;

  const _DraftCard({
    required this.draft,
    required this.onApprove,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      draft.customerName[0],
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      draft.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.aiBubble,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${(draft.confidence * 100).toInt()}%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.aiBubble,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  draft.draftText,
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Edit & Send', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Approve', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerfCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _PerfCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
