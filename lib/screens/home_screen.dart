import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app_theme.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildIllustration(),
                    const SizedBox(height: 48),
                    _buildGetStartedButton(context),
                    const SizedBox(height: 24),
                    _buildFeatureCards(),
                  ]
                  .animate(interval: const Duration(milliseconds: 100))
                  .fadeIn(duration: const Duration(milliseconds: 600))
                  .slideY(begin: 0.2, end: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Nana's Chat Assistant",
          style: AppTheme.headingStyle.copyWith(
            fontSize: 32,
            color: AppTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Your personal AI assistant powered by advanced language models',
          style: AppTheme.bodyStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.smart_toy_outlined,
              size: 100,
              color: AppTheme.primaryColor,
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(seconds: 3),
          color: AppTheme.primaryColor.withOpacity(0.2),
        );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text('Start Chatting'),
    ).animate().shimmer(
      duration: const Duration(seconds: 2),
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      _FeatureItem(
        icon: Icons.chat_outlined,
        title: 'Natural Conversations',
        description:
            'Have human-like conversations with an AI that understands context',
      ),
      _FeatureItem(
        icon: Icons.help_outline,
        title: 'Get Assistance',
        description: 'Ask questions and get accurate, helpful responses',
      ),
      _FeatureItem(
        icon: Icons.history,
        title: 'Chat History',
        description: 'Your conversations are saved for future reference',
      ),
    ];

    return Column(
      children:
          features.map((feature) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature.icon,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.title,
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(feature.description, style: AppTheme.captionStyle),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
