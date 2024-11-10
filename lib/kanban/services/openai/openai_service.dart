import 'dart:convert';
import 'dart:io';

import 'package:fleet/kanban/services/openai/models/chat_response_model.dart';
import 'package:http/http.dart' as http;

final class OpenAIService {

  Future<ChatResponseModel> sendChat(String prompt) async {
    final apiKey = Platform.environment['open_ai_key'];

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {"Authorization": "Bearer $apiKey", "Content-Type": "application/json"},
      body: jsonEncode({
        "model": "gpt-4o",
        // "max_tokens": 64,
        "messages": [{ "role": "user", "content": prompt }]
      })
    );

    var body = jsonDecode(response.body);

    final choice = body["choices"][0];

    final chat = ChatResponseModel(
      choices: [
        ChatChoice(
          message: ChatMessage(
            role: choice["message"]["role"], 
            content: choice["message"]["content"], 
            refusal: choice["message"]["refusal"]
          ),
          finishReason: choice["finish_reason"]
        )
      ], 
      usage: ChatUsage(
        promptTokens: 1,
        completionTokens: 1,
        totalTokens: 1
      )
    );

    return chat;
  }
}