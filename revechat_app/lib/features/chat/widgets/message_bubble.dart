import 'package:flutter/material.dart';
import 'package:revechat_app/core/constants/app_colors.dart';
import 'package:revechat_app/data/mock_data.dart';
import 'package:revechat_app/features/chat/widgets/image_bubble.dart';
import 'package:revechat_app/features/chat/widgets/ai_message_bubble.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onImageTap;

  const MessageBubble({super.key, required this.message, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      return _SystemMessage(message: message);
    }

    if (message.sender == SenderType.ai) {
      return AiMessageBubble(message: message, onImageTap: onImageTap);
    }

    final isCustomer = message.sender == SenderType.customer;
    final alignment = isCustomer ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final bubbleColor = isCustomer ? AppColors.customerBubble : AppColors.humanBubble;
    final textColor = isCustomer ? AppColors.textPrimary : Colors.white;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isCustomer ? 4 : 16),
      bottomRight: Radius.circular(isCustomer ? 16 : 4),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              border: isCustomer ? Border.all(color: AppColors.customerBorder) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: _buildContent(textColor),
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

  Widget _buildContent(Color textColor) {
    switch (message.type) {
      case MessageType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            message.text ?? '',
            style: TextStyle(fontSize: 15, color: textColor, height: 1.4),
          ),
        );

      case MessageType.image:
        return ImageBubble(
          imageUrl: message.imageUrl!,
          onTap: onImageTap,
        );

      case MessageType.imageWithCaption:
        return ImageBubble(
          imageUrl: message.imageUrl!,
          caption: message.caption ?? message.text,
          captionColor: message.sender == SenderType.customer
              ? AppColors.textPrimary
              : Colors.white,
          onTap: onImageTap,
        );

      case MessageType.voice:
        return _VoiceBubble(textColor: textColor);

      case MessageType.productCard:
        return _ProductCardBubble(product: message.productCard!);

      case MessageType.orderCard:
        return _OrderCardBubble(order: message.orderCard!);

      case MessageType.system:
        return const SizedBox.shrink();
    }
  }
}

class _SystemMessage extends StatelessWidget {
  final Message message;
  const _SystemMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _VoiceBubble extends StatelessWidget {
  final Color textColor;
  const _VoiceBubble({required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_filled, color: textColor, size: 32),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 24,
                child: CustomPaint(
                  painter: _WaveformPainter(color: textColor.withOpacity(0.6)),
                ),
              ),
              Text('0:12', style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.7))),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  _WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final heights = [0.3, 0.6, 0.9, 0.5, 0.8, 1.0, 0.4, 0.7, 0.3, 0.6, 0.8, 0.5, 0.3, 0.7, 0.9, 0.4, 0.6, 0.3];
    final spacing = size.width / heights.length;

    for (var i = 0; i < heights.length; i++) {
      final x = i * spacing + spacing / 2;
      final h = size.height * heights[i];
      final top = (size.height - h) / 2;
      canvas.drawLine(Offset(x, top), Offset(x, top + h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProductCardBubble extends StatelessWidget {
  final ProductCard product;
  const _ProductCardBubble({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(Icons.image, size: 40, color: AppColors.textCaption),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.currency}${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: product.inStock
                        ? AppColors.online.withOpacity(0.1)
                        : AppColors.needsHuman.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.inStock ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: product.inStock ? AppColors.online : AppColors.needsHuman,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCardBubble extends StatelessWidget {
  final OrderCard order;
  const _OrderCardBubble({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                order.orderId,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.online.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              order.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.online,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '• $item',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          )),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(
                '${order.currency}${order.total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
