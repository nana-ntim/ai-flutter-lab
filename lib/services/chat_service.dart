import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message.dart';

// API Key - Replace with your actual Gemini API key
const String apiKey = 'AIzaSyA6E3Aer_Oi0TozjsCA5PymL-UF8dirJIE';

class ChatService {
  static const String _storageKey = 'chat_history';

  // Generate a response using Gemini with conversation history
  Future<String> generateResponse(List<Message> messages) async {
    try {
      // If messages is empty, return a default greeting
      if (messages.isEmpty) {
        return "Hello! I'm your AI assistant for Flutter development. How can I help you today?";
      }

      // Create the generative model with better configuration
      final model = GenerativeModel(
        model: 'gemini-1.5-flash', // Using the correct model name
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7, // Add some creativity (0.0-1.0)
          topK: 40, // Sample from top 40 tokens
          topP: 0.95, // Sample from 95% probability mass
          maxOutputTokens: 800, // Longer responses
        ),
      );

      // System instruction to guide responses
      final systemInstruction =
          """You are an AI assistant who loves to talk to people and help with anything they need in general. You always want to come off really friendly but not so friendly that you sound needy. Just an amazing friend to talk to and can help with anything at all.""";

      // Prepare conversation history for context
      final List<Content> prompt = [];

      // Add system instruction
      prompt.add(Content.text(systemInstruction));

      // Add up to 5 previous messages for context
      final historyMessages =
          messages.length > 1
              ? messages
                  .sublist(0, messages.length - 1)
                  .reversed
                  .take(5)
                  .toList()
                  .reversed
                  .toList()
              : <Message>[];

      // Add chat history to provide context
      for (final msg in historyMessages) {
        if (msg.isUser) {
          prompt.add(Content.text("User: ${msg.content}"));
        } else {
          prompt.add(Content.text("Assistant: ${msg.content}"));
        }
      }

      // Add the current user message
      prompt.add(Content.text("User: ${messages.last.content}"));
      prompt.add(Content.text("Assistant:"));

      // Log what we're sending (for debugging)
      print(
        'Sending prompt to Gemini: ${prompt.map((c) => c.toString()).join("\n")}',
      );

      // Send the prompt with history to Gemini
      final response = await model.generateContent(prompt);

      // Extract and return the text
      String responseText =
          response.text ?? "Sorry, I couldn't generate a response.";

      // Make sure we don't return the "Assistant:" prefix if it's included
      if (responseText.startsWith("Assistant:")) {
        responseText = responseText.substring("Assistant:".length).trim();
      }

      return responseText;
    } catch (e) {
      print('Error generating response: $e');

      // Return a helpful error message
      if (e.toString().contains('API key')) {
        return "Error: Please replace the API key in chat_service.dart with your own Gemini API key.";
      } else if (e.toString().contains('model')) {
        return "Error: There's an issue with the AI model. Please check that you have access to the Gemini API.";
      } else if (e.toString().contains('INVALID_ARGUMENT') &&
          e.toString().contains('safety settings')) {
        // This might occur if the prompt trips safety settings
        return "I'm not able to respond to that type of query. Let's talk about Flutter and mobile development instead!";
      }

      return "Sorry, I encountered an error connecting to the AI service. Please check your internet connection and API configuration.";
    }
  }

  // Save chat history to local storage
  Future<void> saveMessages(List<Message> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = messages.map((msg) => msg.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(messagesJson));
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  // Load chat history from local storage
  Future<List<Message>> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesString = prefs.getString(_storageKey);

      if (messagesString == null) {
        return [];
      }

      final List<dynamic> messagesJson = jsonDecode(messagesString);
      return messagesJson.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      print('Error loading messages: $e');
      return [];
    }
  }

  // Clear chat history
  Future<void> clearMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing messages: $e');
    }
  }
}
