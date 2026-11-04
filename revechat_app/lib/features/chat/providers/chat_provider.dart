import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revechat_app/data/mock_data.dart';

final conversationsProvider =
    StateNotifierProvider<ChatNotifier, List<Conversation>>((ref) {
  return ChatNotifier();
});

final aiGlobalProvider = StateProvider<bool>((ref) => true);

class ChatNotifier extends StateNotifier<List<Conversation>> {
  ChatNotifier() : super(mockConversations);

  void toggleAi(String conversationId, bool value) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(aiEnabled: value, isAiHandled: value)
        else
          c,
    ];
  }

  void takeOver(String conversationId) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(
            aiEnabled: false,
            isAiHandled: false,
            needsHuman: false,
            assignedTo: 'Nusrat',
            messages: [
              ...c.messages,
              Message(
                id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
                type: MessageType.system,
                sender: SenderType.human,
                text: 'Nusrat took over the conversation',
                timestamp: DateTime.now(),
              ),
            ],
          )
        else
          c,
    ];
  }

  void sendMessage(String conversationId, String text) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(
            messages: [
              ...c.messages,
              Message(
                id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
                type: MessageType.text,
                sender: SenderType.human,
                text: text,
                timestamp: DateTime.now(),
              ),
            ],
            lastMessagePreview: text,
            lastMessageTime: DateTime.now(),
          )
        else
          c,
    ];
  }

  void approveAiDraft(String conversationId, String draftText) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(
            messages: [
              ...c.messages,
              Message(
                id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
                type: MessageType.text,
                sender: SenderType.ai,
                text: draftText,
                timestamp: DateTime.now(),
                aiConfidence: 0.95,
              ),
            ],
            lastMessagePreview: draftText,
            lastMessageTime: DateTime.now(),
          )
        else
          c,
    ];
  }

  Conversation? getConversation(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
