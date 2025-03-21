import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;

  const ChatScreen({Key? key, this.initialPrompt}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _showWelcomeScreen = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final savedMessages = await _chatService.loadMessages();

    setState(() {
      _messages.clear();
      _messages.addAll(savedMessages);
      _showWelcomeScreen = _messages.isEmpty;
    });

    // If we have messages, scroll to bottom
    if (_messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(Message(content: content, isUser: true));

      // Add loading message
      _messages.add(Message.loading());

      _isLoading = true;
      _showWelcomeScreen = false;
    });

    // Scroll to show the message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Get AI response
    final response = await _chatService.generateResponse(_messages);

    setState(() {
      // Remove loading message
      _messages.removeLast();

      // Add AI response
      _messages.add(Message(content: response, isUser: false));

      _isLoading = false;
    });

    // Save messages to storage
    await _chatService.saveMessages(_messages);

    // Scroll to show the AI response
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _clearChat() async {
    final chatService = ChatService();
    await chatService.clearMessages();

    setState(() {
      _messages.clear();
      _showWelcomeScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Chat',
          style: AppTheme.subheadingStyle.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearChatDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _showWelcomeScreen && _messages.isEmpty
                    ? _buildWelcomeView()
                    : _buildChatView(),
          ),
          ChatInput(onSendMessage: _sendMessage, isLoading: _isLoading),
        ],
      ),
    );
  }

  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: const Duration(seconds: 3),
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
              const SizedBox(height: 40),
              Text(
                'Welcome to AI Chat',
                style: AppTheme.headingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Ask me anything! I can help with information, creative ideas, or just chat about your day.',
                style: AppTheme.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildExamplePrompts(),
            ],
          )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildExamplePrompts() {
    final examples = [
      'How do I learn Flutter?',
      'Tell me a fun fact',
      'What can you help me with?',
    ];

    return Column(
      children:
          examples.map((prompt) {
            return GestureDetector(
              onTap: () => _sendMessage(prompt),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(prompt, style: AppTheme.bodyStyle),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildChatView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isLastMessage = index == _messages.length - 1;

        // Determine if we should show avatar based on message groups
        bool showAvatar = true;
        if (index > 0) {
          final prevMessage = _messages[index - 1];
          if (prevMessage.isUser == message.isUser) {
            showAvatar = false;
          }
        }

        return ChatBubble(
          message: message,
          showAvatar: showAvatar || isLastMessage,
        );
      },
    );
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Chat'),
          content: const Text(
            'Are you sure you want to clear the entire chat history?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _clearChat();
                Navigator.of(context).pop();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
