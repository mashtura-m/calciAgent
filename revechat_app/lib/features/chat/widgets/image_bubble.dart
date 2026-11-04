import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final Color? captionColor;
  final VoidCallback? onTap;

  const ImageBubble({
    super.key,
    required this.imageUrl,
    this.caption,
    this.captionColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: caption != null
                ? const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )
                : BorderRadius.circular(16),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SizedBox(
                  height: 150,
                  child: Center(
                    child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Text(
                caption!,
                style: TextStyle(
                  fontSize: 15,
                  color: captionColor ?? Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
