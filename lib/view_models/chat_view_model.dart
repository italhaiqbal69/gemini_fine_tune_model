import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gemini_ai_test/model/message_model.dart';

class ChatViewModel with ChangeNotifier {
  final List<Message> _messages = [];
  late final GenerativeModel _gemini;

  ChatViewModel(String apiKey) {
    final generationConfig = GenerationConfig(
      temperature:
          0.7, // Controls randomness (0.0 = deterministic, 1.0 = creative)
      maxOutputTokens: 200, // Maximum response length
      topP: 0.9, // Nucleus sampling (higher = more diverse output)
      topK: 50, // Higher K = better diversity
      stopSequences: [], // Add stop words if needed
    );

    final safetySettings = [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
    ];

    final systemInstruction = Content.system(
        "You are a prescription-focused medical assistant. Your primary role is to assist users in understanding their prescribed medications, dosages, side effects, interactions, and general healthcare guidance. "
        "Always start with a clear, direct answer in the first sentence. "
        "Then, in a new paragraph, provide brief and relevant supporting details if needed. "
        "Keep your entire response concise and avoid overly long explanations. "
        "Only include a 'Disclaimer:' paragraph when the topic involves health decisions, potential risks, or actions that should be confirmed with a professional. "
        "Do not provide brand-specific medication names tied to a particular country (e.g., US or UK). Stick to generic drug names unless the user specifically mentions a local product. "
        "You must NOT provide diagnoses, prescribe medications, or replace professional medical advice. "
        "Avoid answering any questions that are unrelated to medicine or healthcare. If a user asks an off-topic question, politely decline and redirect them to a relevant medical topic.");

    _gemini = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: generationConfig,
      safetySettings: safetySettings,
      systemInstruction: systemInstruction,
    );
  }

  List<Message> get messages => _messages;

  Future<void> sendMessage(String content) async {
    final userMessage = Message(content: content, isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    try {
      final response = await _gemini.generateContent([Content.text(content)]);

      final botResponse = response.text ?? "No response from Gemini";
      final botMessage = Message(content: botResponse, isUser: false);
      _messages.add(botMessage);
    } catch (e) {
      final errorMessage = Message(content: "Error: $e", isUser: false);
      _messages.add(errorMessage);
    }

    notifyListeners();
  }
}
