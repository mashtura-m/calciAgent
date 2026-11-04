import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/features/chat/providers/chat_provider.dart';
import 'package:revechat_app/features/inbox/widgets/conversation_card.dart';

enum InboxFilter { all, mine, aiHandled, needsHuman }

class InboxListScreen extends ConsumerStatefulWidget {
  const InboxListScreen({super.key});

  @override
  ConsumerState<InboxListScreen> createState() => _InboxListScreenState();
}

class _InboxListScreenState extends ConsumerState<InboxListScreen> {
  InboxFilter _selectedFilter = InboxFilter.all;

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(conversationsProvider);
    final filtered = _applyFilter(conversations);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inbox',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${conversations.where((c) => c.unreadCount > 0).length} unread conversations',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _FilterChip(
                        label: 'All',
                        count: conversations.length,
                        isSelected: _selectedFilter == InboxFilter.all,
                        onSelected: () => setState(() => _selectedFilter = InboxFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Mine',
                        count: conversations.where((c) => c.assignedTo == 'Nusrat').length,
                        isSelected: _selectedFilter == InboxFilter.mine,
                        onSelected: () => setState(() => _selectedFilter = InboxFilter.mine),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'AI Handled',
                        count: conversations.where((c) => c.isAiHandled).length,
                        isSelected: _selectedFilter == InboxFilter.aiHandled,
                        onSelected: () => setState(() => _selectedFilter = InboxFilter.aiHandled),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Needs Human',
                        count: conversations.where((c) => c.needsHuman).length,
                        isSelected: _selectedFilter == InboxFilter.needsHuman,
                        onSelected: () => setState(() => _selectedFilter = InboxFilter.needsHuman),
                        badgeColor: AppColors.needsHuman,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final conversation = filtered[index];
                  return Dismissible(
                    key: Key(conversation.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: AppColors.primary.withOpacity(0.1),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _DismissAction(
                            icon: Icons.person_add_outlined,
                            label: 'Assign',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 16),
                          _DismissAction(
                            icon: Icons.check_circle_outline,
                            label: 'Resolve',
                            color: AppColors.online,
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (_) async => false,
                    child: ConversationCard(
                      conversation: conversation,
                      onTap: () => context.push('/chat/${conversation.id}'),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _applyFilter(List<dynamic> conversations) {
    switch (_selectedFilter) {
      case InboxFilter.all:
        return conversations;
      case InboxFilter.mine:
        return conversations.where((c) => c.assignedTo == 'Nusrat').toList();
      case InboxFilter.aiHandled:
        return conversations.where((c) => c.isAiHandled).toList();
      case InboxFilter.needsHuman:
        return conversations.where((c) => c.needsHuman).toList();
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? badgeColor;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onSelected,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : (badgeColor ?? AppColors.textCaption).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : (badgeColor ?? AppColors.textSecondary),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DismissAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DismissAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
