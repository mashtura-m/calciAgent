import 'package:flutter/material.dart';

enum MessageType { text, image, imageWithCaption, voice, productCard, orderCard, system }
enum SenderType { customer, ai, human }
enum ConversationStatus { active, resolved, pending }
enum ChannelType { whatsApp, messenger, instagram, livechat }

class Message {
  final String id;
  final MessageType type;
  final SenderType sender;
  final String? text;
  final String? caption;
  final String? imageUrl;
  final DateTime timestamp;
  final double? aiConfidence;
  final ProductCard? productCard;
  final OrderCard? orderCard;
  final bool isRead;

  const Message({
    required this.id,
    required this.type,
    required this.sender,
    this.text,
    this.caption,
    this.imageUrl,
    required this.timestamp,
    this.aiConfidence,
    this.productCard,
    this.orderCard,
    this.isRead = true,
  });
}

class ProductCard {
  final String name;
  final String imageUrl;
  final double price;
  final String currency;
  final bool inStock;

  const ProductCard({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.currency = '৳',
    this.inStock = true,
  });
}

class OrderCard {
  final String orderId;
  final String status;
  final double total;
  final String currency;
  final DateTime orderDate;
  final List<String> items;

  const OrderCard({
    required this.orderId,
    required this.status,
    required this.total,
    this.currency = '৳',
    required this.orderDate,
    required this.items,
  });
}

class Conversation {
  final String id;
  final String customerName;
  final String? customerAvatar;
  final ChannelType channel;
  final ConversationStatus status;
  final bool isAiHandled;
  final bool aiEnabled;
  final int unreadCount;
  final String? assignedTo;
  final List<Message> messages;
  final String? lastMessagePreview;
  final DateTime lastMessageTime;
  final bool needsHuman;

  const Conversation({
    required this.id,
    required this.customerName,
    this.customerAvatar,
    required this.channel,
    required this.status,
    this.isAiHandled = false,
    this.aiEnabled = true,
    this.unreadCount = 0,
    this.assignedTo,
    required this.messages,
    this.lastMessagePreview,
    required this.lastMessageTime,
    this.needsHuman = false,
  });

  Conversation copyWith({
    bool? aiEnabled,
    bool? isAiHandled,
    bool? needsHuman,
    List<Message>? messages,
    String? lastMessagePreview,
    DateTime? lastMessageTime,
    String? assignedTo,
    int? unreadCount,
    ConversationStatus? status,
  }) {
    return Conversation(
      id: id,
      customerName: customerName,
      customerAvatar: customerAvatar,
      channel: channel,
      status: status ?? this.status,
      isAiHandled: isAiHandled ?? this.isAiHandled,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      unreadCount: unreadCount ?? this.unreadCount,
      assignedTo: assignedTo ?? this.assignedTo,
      messages: messages ?? this.messages,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      needsHuman: needsHuman ?? this.needsHuman,
    );
  }
}

class Agent {
  final String id;
  final String name;
  final String avatar;
  final bool isOnline;
  final String role;
  final int resolvedToday;
  final Duration avgResponseTime;

  const Agent({
    required this.id,
    required this.name,
    required this.avatar,
    this.isOnline = true,
    required this.role,
    this.resolvedToday = 0,
    this.avgResponseTime = const Duration(minutes: 2),
  });
}

class AiDraft {
  final String id;
  final String conversationId;
  final String customerName;
  final String draftText;
  final double confidence;
  final DateTime createdAt;

  const AiDraft({
    required this.id,
    required this.conversationId,
    required this.customerName,
    required this.draftText,
    required this.confidence,
    required this.createdAt,
  });
}

class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final ChannelType lastChannel;
  final int totalConversations;
  final DateTime lastSeen;

  const Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.lastChannel,
    this.totalConversations = 1,
    required this.lastSeen,
  });
}

class Order {
  final String id;
  final String customerName;
  final String status;
  final double total;
  final String currency;
  final DateTime orderDate;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.customerName,
    required this.status,
    required this.total,
    this.currency = '৳',
    required this.orderDate,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// ---- MOCK DATA ----

final DateTime _now = DateTime.now();

final List<Conversation> mockConversations = [
  Conversation(
    id: '1',
    customerName: 'Fatima Akter',
    channel: ChannelType.whatsApp,
    status: ConversationStatus.active,
    isAiHandled: true,
    aiEnabled: true,
    unreadCount: 3,
    lastMessagePreview: 'এই প্রোডাক্টটা কি এখন available?',
    lastMessageTime: _now.subtract(const Duration(minutes: 2)),
    messages: [
      Message(
        id: 'm1_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'হ্যালো, আমি একটা ড্রেস দেখেছিলাম আপনাদের পেজে',
        timestamp: _now.subtract(const Duration(minutes: 30)),
      ),
      Message(
        id: 'm1_2',
        type: MessageType.imageWithCaption,
        sender: SenderType.customer,
        text: 'এইটা ফেটে গেছে',
        caption: 'এইটা ফেটে গেছে',
        imageUrl: 'https://picsum.photos/seed/dress1/400/300',
        timestamp: _now.subtract(const Duration(minutes: 28)),
      ),
      Message(
        id: 'm1_3',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'আসসালামু আলাইকুম ফাতিমা! আপনার পণ্যটি নিয়ে সমস্যার জন্য আমরা দুঃখিত। আমি এখনই আপনাকে সাহায্য করছি। পণ্যটি কবে ডেলিভারি হয়েছিল?',
        timestamp: _now.subtract(const Duration(minutes: 27)),
        aiConfidence: 0.92,
      ),
      Message(
        id: 'm1_4',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'গত সোমবার ডেলিভারি হয়েছে',
        timestamp: _now.subtract(const Duration(minutes: 25)),
      ),
      Message(
        id: 'm1_5',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'ধন্যবাদ! আপনার অর্ডারটি আমাদের রিটার্ন পলিসির মধ্যে আছে। আমি একজন এজেন্টকে কানেক্ট করছি যিনি আপনার রিটার্ন প্রসেস করবেন।',
        timestamp: _now.subtract(const Duration(minutes: 24)),
        aiConfidence: 0.85,
      ),
      Message(
        id: 'm1_6',
        type: MessageType.system,
        sender: SenderType.ai,
        text: 'AI Sara requested handover to human agent',
        timestamp: _now.subtract(const Duration(minutes: 23)),
      ),
      Message(
        id: 'm1_7',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'এই প্রোডাক্টটা কি এখন available?',
        timestamp: _now.subtract(const Duration(minutes: 2)),
      ),
    ],
    needsHuman: true,
  ),
  Conversation(
    id: '2',
    customerName: 'Rahim Uddin',
    channel: ChannelType.messenger,
    status: ConversationStatus.active,
    isAiHandled: true,
    aiEnabled: true,
    unreadCount: 0,
    assignedTo: 'Nusrat',
    lastMessagePreview: 'Order #1234 has been shipped!',
    lastMessageTime: _now.subtract(const Duration(minutes: 15)),
    messages: [
      Message(
        id: 'm2_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'আমার অর্ডার কোথায়? অনেকদিন হয়ে গেছে',
        timestamp: _now.subtract(const Duration(hours: 1)),
      ),
      Message(
        id: 'm2_2',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'রহিম ভাই, আপনার অর্ডার #1234 চেক করছি। একটু অপেক্ষা করুন।',
        timestamp: _now.subtract(const Duration(minutes: 58)),
        aiConfidence: 0.95,
      ),
      Message(
        id: 'm2_3',
        type: MessageType.orderCard,
        sender: SenderType.ai,
        text: 'Order Details',
        timestamp: _now.subtract(const Duration(minutes: 57)),
        orderCard: OrderCard(
          orderId: 'ORD-1234',
          status: 'Shipped',
          total: 2450,
          orderDate: _now.subtract(const Duration(days: 3)),
          items: ['Blue Polo Shirt x1', 'Black Chinos x1'],
        ),
        aiConfidence: 0.97,
      ),
      Message(
        id: 'm2_4',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'আপনার অর্ডারটি শিপ করা হয়েছে! ডেলিভারি হবে আগামীকালের মধ্যে। ট্র্যাকিং নম্বর: TRK-5678',
        timestamp: _now.subtract(const Duration(minutes: 15)),
        aiConfidence: 0.97,
      ),
    ],
  ),
  Conversation(
    id: '3',
    customerName: 'Sumaiya Rahman',
    channel: ChannelType.instagram,
    status: ConversationStatus.active,
    isAiHandled: false,
    aiEnabled: false,
    unreadCount: 1,
    assignedTo: 'Nusrat',
    lastMessagePreview: '📷 Image: Red Saree Collection',
    lastMessageTime: _now.subtract(const Duration(minutes: 45)),
    messages: [
      Message(
        id: 'm3_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'Hi! I love your new collection 😍',
        timestamp: _now.subtract(const Duration(hours: 2)),
      ),
      Message(
        id: 'm3_2',
        type: MessageType.text,
        sender: SenderType.human,
        text: 'Thank you Sumaiya! Which collection are you interested in?',
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 50)),
      ),
      Message(
        id: 'm3_3',
        type: MessageType.imageWithCaption,
        sender: SenderType.customer,
        caption: 'Red Saree Collection',
        imageUrl: 'https://picsum.photos/seed/saree1/400/500',
        timestamp: _now.subtract(const Duration(minutes: 45)),
      ),
      Message(
        id: 'm3_4',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'এই শাড়িটার price কত?',
        timestamp: _now.subtract(const Duration(minutes: 44)),
      ),
    ],
  ),
  Conversation(
    id: '4',
    customerName: 'Kamal Hossain',
    channel: ChannelType.whatsApp,
    status: ConversationStatus.active,
    isAiHandled: true,
    aiEnabled: true,
    unreadCount: 0,
    lastMessagePreview: 'Size chart পাঠান please',
    lastMessageTime: _now.subtract(const Duration(hours: 1)),
    messages: [
      Message(
        id: 'm4_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'ভাই XL size আছে?',
        timestamp: _now.subtract(const Duration(hours: 2)),
      ),
      Message(
        id: 'm4_2',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'জি ভাই, XL সাইজ available আছে! আপনি কোন প্রোডাক্টের কথা বলছেন?',
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 58)),
        aiConfidence: 0.91,
      ),
      Message(
        id: 'm4_3',
        type: MessageType.productCard,
        sender: SenderType.ai,
        text: 'Premium Cotton Polo - XL',
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 55)),
        productCard: ProductCard(
          name: 'Premium Cotton Polo Shirt',
          imageUrl: 'https://picsum.photos/seed/polo1/400/400',
          price: 1250,
        ),
        aiConfidence: 0.88,
      ),
      Message(
        id: 'm4_4',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'Size chart পাঠান please',
        timestamp: _now.subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Conversation(
    id: '5',
    customerName: 'Nadia Islam',
    channel: ChannelType.livechat,
    status: ConversationStatus.active,
    isAiHandled: false,
    aiEnabled: true,
    unreadCount: 5,
    lastMessagePreview: 'I need to speak with a manager NOW',
    lastMessageTime: _now.subtract(const Duration(minutes: 5)),
    needsHuman: true,
    messages: [
      Message(
        id: 'm5_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'This is the third time I am asking about my refund!',
        timestamp: _now.subtract(const Duration(minutes: 20)),
      ),
      Message(
        id: 'm5_2',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'I understand your frustration, Nadia. Let me check your refund status right away.',
        timestamp: _now.subtract(const Duration(minutes: 19)),
        aiConfidence: 0.78,
      ),
      Message(
        id: 'm5_3',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'I was told 3-5 business days and it has been 10 days!',
        timestamp: _now.subtract(const Duration(minutes: 15)),
      ),
      Message(
        id: 'm5_4',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'I apologize for the delay. Your refund for order #5678 (৳3,200) is being processed. Let me connect you with a senior agent who can expedite this.',
        timestamp: _now.subtract(const Duration(minutes: 14)),
        aiConfidence: 0.72,
      ),
      Message(
        id: 'm5_5',
        type: MessageType.system,
        sender: SenderType.ai,
        text: 'AI confidence low - Handover requested',
        timestamp: _now.subtract(const Duration(minutes: 13)),
      ),
      Message(
        id: 'm5_6',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'I need to speak with a manager NOW',
        timestamp: _now.subtract(const Duration(minutes: 5)),
      ),
    ],
  ),
  Conversation(
    id: '6',
    customerName: 'Arif Mahmud',
    channel: ChannelType.whatsApp,
    status: ConversationStatus.resolved,
    isAiHandled: true,
    aiEnabled: true,
    unreadCount: 0,
    assignedTo: 'Nusrat',
    lastMessagePreview: 'ধন্যবাদ! অনেক ভালো সার্ভিস 👍',
    lastMessageTime: _now.subtract(const Duration(hours: 3)),
    messages: [
      Message(
        id: 'm6_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'ভাই পেমেন্ট করেছি bKash এ',
        timestamp: _now.subtract(const Duration(hours: 4)),
      ),
      Message(
        id: 'm6_2',
        type: MessageType.image,
        sender: SenderType.customer,
        imageUrl: 'https://picsum.photos/seed/bkash1/400/600',
        timestamp: _now.subtract(const Duration(hours: 3, minutes: 55)),
      ),
      Message(
        id: 'm6_3',
        type: MessageType.text,
        sender: SenderType.human,
        text: 'পেমেন্ট কনফার্ম হয়েছে আরিফ ভাই! আপনার অর্ডার প্রসেস করা হচ্ছে। ২-৩ দিনের মধ্যে ডেলিভারি পাবেন।',
        timestamp: _now.subtract(const Duration(hours: 3, minutes: 30)),
      ),
      Message(
        id: 'm6_4',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'ধন্যবাদ! অনেক ভালো সার্ভিস 👍',
        timestamp: _now.subtract(const Duration(hours: 3)),
      ),
    ],
  ),
  Conversation(
    id: '7',
    customerName: 'Tasnim Jahan',
    channel: ChannelType.messenger,
    status: ConversationStatus.active,
    isAiHandled: true,
    aiEnabled: true,
    unreadCount: 2,
    lastMessagePreview: 'Voice message (0:12)',
    lastMessageTime: _now.subtract(const Duration(minutes: 30)),
    messages: [
      Message(
        id: 'm7_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'আপু, কালকে যে অর্ডার দিলাম সেটা কি কনফার্ম হয়েছে?',
        timestamp: _now.subtract(const Duration(hours: 1)),
      ),
      Message(
        id: 'm7_2',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'হ্যাঁ তাসনিম! আপনার অর্ডার কনফার্ম হয়েছে। অর্ডার নম্বর: ORD-7890। ডেলিভারি হবে ২ দিনের মধ্যে।',
        timestamp: _now.subtract(const Duration(minutes: 58)),
        aiConfidence: 0.94,
      ),
      Message(
        id: 'm7_3',
        type: MessageType.voice,
        sender: SenderType.customer,
        text: 'Voice message (0:12)',
        timestamp: _now.subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Conversation(
    id: '8',
    customerName: 'Mehedi Hassan',
    channel: ChannelType.instagram,
    status: ConversationStatus.pending,
    isAiHandled: false,
    aiEnabled: true,
    unreadCount: 1,
    lastMessagePreview: 'Collab করতে interested?',
    lastMessageTime: _now.subtract(const Duration(hours: 5)),
    messages: [
      Message(
        id: 'm8_1',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'Hi! I am a fashion blogger with 50K followers. Would love to collaborate!',
        timestamp: _now.subtract(const Duration(hours: 6)),
      ),
      Message(
        id: 'm8_2',
        type: MessageType.text,
        sender: SenderType.ai,
        text: 'Hello Mehedi! Thank you for reaching out. We would love to explore collaboration opportunities! Let me connect you with our marketing team.',
        timestamp: _now.subtract(const Duration(hours: 5, minutes: 55)),
        aiConfidence: 0.89,
      ),
      Message(
        id: 'm8_3',
        type: MessageType.text,
        sender: SenderType.customer,
        text: 'Collab করতে interested?',
        timestamp: _now.subtract(const Duration(hours: 5)),
      ),
    ],
  ),
];

final List<AiDraft> mockAiDrafts = [
  AiDraft(
    id: 'd1',
    conversationId: '1',
    customerName: 'Fatima Akter',
    draftText: 'ফাতিমা, আপনার রিটার্ন রিকোয়েস্ট প্রসেস করা হয়েছে। পিকআপ আগামীকাল সকাল ১০টায় হবে। রেফান্ড ৩-৫ কার্যদিবসের মধ্যে পাবেন।',
    confidence: 0.88,
    createdAt: _now.subtract(const Duration(minutes: 5)),
  ),
  AiDraft(
    id: 'd2',
    conversationId: '4',
    customerName: 'Kamal Hossain',
    draftText: 'কামাল ভাই, এই হলো আমাদের সাইজ চার্ট: S(36"), M(38"), L(40"), XL(42"), XXL(44")। আপনার জন্য XL recommend করব।',
    confidence: 0.93,
    createdAt: _now.subtract(const Duration(minutes: 10)),
  ),
  AiDraft(
    id: 'd3',
    conversationId: '7',
    customerName: 'Tasnim Jahan',
    draftText: 'তাসনিম, আপনার ভয়েস মেসেজ শুনেছি। হ্যাঁ, ক্যাশ অন ডেলিভারি অপশন available আছে। ডেলিভারির সময় পেমেন্ট করতে পারবেন।',
    confidence: 0.82,
    createdAt: _now.subtract(const Duration(minutes: 15)),
  ),
];

final List<Contact> mockContacts = [
  Contact(id: 'c1', name: 'Fatima Akter', email: 'fatima@email.com', phone: '+8801711111111', lastChannel: ChannelType.whatsApp, totalConversations: 5, lastSeen: _now.subtract(const Duration(minutes: 2))),
  Contact(id: 'c2', name: 'Rahim Uddin', email: 'rahim@email.com', phone: '+8801722222222', lastChannel: ChannelType.messenger, totalConversations: 3, lastSeen: _now.subtract(const Duration(minutes: 15))),
  Contact(id: 'c3', name: 'Sumaiya Rahman', phone: '+8801733333333', lastChannel: ChannelType.instagram, totalConversations: 2, lastSeen: _now.subtract(const Duration(minutes: 45))),
  Contact(id: 'c4', name: 'Kamal Hossain', email: 'kamal@email.com', phone: '+8801744444444', lastChannel: ChannelType.whatsApp, totalConversations: 7, lastSeen: _now.subtract(const Duration(hours: 1))),
  Contact(id: 'c5', name: 'Nadia Islam', email: 'nadia@email.com', phone: '+8801755555555', lastChannel: ChannelType.livechat, totalConversations: 4, lastSeen: _now.subtract(const Duration(minutes: 5))),
  Contact(id: 'c6', name: 'Arif Mahmud', phone: '+8801766666666', lastChannel: ChannelType.whatsApp, totalConversations: 2, lastSeen: _now.subtract(const Duration(hours: 3))),
  Contact(id: 'c7', name: 'Tasnim Jahan', email: 'tasnim@email.com', lastChannel: ChannelType.messenger, totalConversations: 6, lastSeen: _now.subtract(const Duration(minutes: 30))),
  Contact(id: 'c8', name: 'Mehedi Hassan', email: 'mehedi@email.com', lastChannel: ChannelType.instagram, totalConversations: 1, lastSeen: _now.subtract(const Duration(hours: 5))),
];

final List<Order> mockOrders = [
  Order(id: 'ORD-1234', customerName: 'Rahim Uddin', status: 'Shipped', total: 2450, orderDate: _now.subtract(const Duration(days: 3)), items: [OrderItem(name: 'Blue Polo Shirt', quantity: 1, price: 1250), OrderItem(name: 'Black Chinos', quantity: 1, price: 1200)]),
  Order(id: 'ORD-5678', customerName: 'Nadia Islam', status: 'Refund Pending', total: 3200, orderDate: _now.subtract(const Duration(days: 12)), items: [OrderItem(name: 'Red Silk Saree', quantity: 1, price: 3200)]),
  Order(id: 'ORD-7890', customerName: 'Tasnim Jahan', status: 'Confirmed', total: 1800, orderDate: _now.subtract(const Duration(days: 1)), items: [OrderItem(name: 'White Kurti', quantity: 1, price: 950), OrderItem(name: 'Palazzo Pants', quantity: 1, price: 850)]),
  Order(id: 'ORD-3456', customerName: 'Arif Mahmud', status: 'Processing', total: 4500, orderDate: _now.subtract(const Duration(days: 1)), items: [OrderItem(name: 'Formal Suit Set', quantity: 1, price: 4500)]),
  Order(id: 'ORD-9012', customerName: 'Fatima Akter', status: 'Return Requested', total: 1650, orderDate: _now.subtract(const Duration(days: 7)), items: [OrderItem(name: 'Floral Dress', quantity: 1, price: 1650)]),
  Order(id: 'ORD-2345', customerName: 'Kamal Hossain', status: 'Delivered', total: 2100, orderDate: _now.subtract(const Duration(days: 5)), items: [OrderItem(name: 'Premium Cotton Polo', quantity: 1, price: 1250), OrderItem(name: 'Denim Jeans', quantity: 1, price: 850)]),
];

final Agent currentAgent = Agent(
  id: 'a1',
  name: 'Nusrat',
  avatar: '',
  role: 'Senior Support Agent',
  resolvedToday: 12,
  avgResponseTime: Duration(minutes: 2, seconds: 15),
);

final List<String> quickReplies = [
  'ধন্যবাদ! আর কিছু লাগলে জানাবেন 😊',
  'আপনার অর্ডার প্রসেস হচ্ছে',
  'ডেলিভারি ২-৩ দিনের মধ্যে হবে',
  'আমি চেক করে জানাচ্ছি',
  'Cash on Delivery available',
  'Size chart পাঠাচ্ছি',
];
