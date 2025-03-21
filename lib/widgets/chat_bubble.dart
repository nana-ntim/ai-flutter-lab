import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool showAvatar;

  const ChatBubble({Key? key, required this.message, this.showAvatar = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser && showAvatar) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child:
                message.isLoading
                    ? _buildLoadingBubble(context)
                    : _buildMessageBubble(context),
          ),
          const SizedBox(width: 8),
          if (message.isUser && showAvatar) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor:
          message.isUser ? AppTheme.accentColor : AppTheme.primaryColor,
      radius: 16,
      child: Icon(
        message.isUser ? Icons.person : Icons.smart_toy_outlined,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingBubble(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.botBubbleColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(1, 1),
                    end: const Offset(0.6, 0.6),
                  )
                  .then()
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(width: 8),
              Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                    delay: const Duration(milliseconds: 300),
                  )
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(1, 1),
                    end: const Offset(0.6, 0.6),
                  )
                  .then()
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(width: 8),
              Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                    delay: const Duration(milliseconds: 600),
                  )
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(1, 1),
                    end: const Offset(0.6, 0.6),
                  )
                  .then()
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1, 1),
                  ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMessageBubble(BuildContext context) {
    final bubbleColor =
        message.isUser ? AppTheme.userBubbleColor : AppTheme.botBubbleColor;

    // Create different border radius based on user/bot
    final borderRadius =
        message.isUser
            ? const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(5),
            )
            : const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            );

    return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.content, style: AppTheme.bodyStyle),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  message.formattedTime,
                  style: AppTheme.captionStyle,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }
}
